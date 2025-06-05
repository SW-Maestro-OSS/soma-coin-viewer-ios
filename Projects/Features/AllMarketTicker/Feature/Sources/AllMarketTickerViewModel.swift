//
//  AllMarketTickerViewModel.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/5/24.
//

import SwiftUI
import Combine

import BaseFeature
import CoinDetailFeature
import DomainInterface
import I18N
import AlertShooter
import WebSocketManagementHelper
import CoreUtil

public protocol AllMarketTickerRouting: AnyObject { }

public enum AllMarketTickerPageListenerRequest {
    case presentCoinDetailPage(listener: CoinDetailPageListener, symbolInfo: CoinSymbolInfo)
    case dismissCoinDetailPage
}

public protocol AllMarketTickerPageListener: AnyObject {
    func request(_ request: AllMarketTickerPageListenerRequest)
}

enum AllMarketTickerAction {
    // View event
    case onAppear
    case onDisappear
    case sortSelectionButtonTapped(type: SortSelectionCellType)
    case coinRowIsTapped(coinInfo: TickerCellRO)
    case enterBackground
    case getBackToForeground
    
    
    // Internal action
    case tickerListFetched(list: TickerList)
    case updateSortSelectionButtons(languageType: LanguageType, currenyType: CurrencyType)
    case updateGridType(type: GridType)
}

final class AllMarketTickerViewModel: UDFObservableObject, AllMarketTickerViewModelable {
    
    // Dependency
    private let useCase: AllMarketTickersUseCase
    private let alertShooter: AlertShooter
    private let webSocketHelper: WebSocketManagementHelper
    private let i18NManager: I18NManager
    private let localizedStrProvider: LocalizedStrProvider
    
    
    // Router
    weak var router: AllMarketTickerRouting?
    
    
    // Listener
    weak var listener: AllMarketTickerPageListener?
    
    
    // State
    @Published var state: State = .init(sortSelectionCells: [], tickerRowCount: 0)
    private let tickerRowCount: Int = 30
    private var isFirstAppear: Bool = true
    
    
    // Action
    typealias Action = AllMarketTickerAction
    var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    
    init(
        useCase: AllMarketTickersUseCase,
        alertShooter: AlertShooter,
        webSocketHelper: WebSocketManagementHelper,
        i18NManager: I18NManager,
        localizedStrProvider: LocalizedStrProvider
    ) {
        self.useCase = useCase
        self.alertShooter = alertShooter
        self.webSocketHelper = webSocketHelper
        self.i18NManager = i18NManager
        self.localizedStrProvider = localizedStrProvider
        
        let sortSelectionCells = createInitialSortSelectonROs()
        let initialState: State = .init(sortSelectionCells: sortSelectionCells, tickerRowCount: Int(tickerRowCount))
        self._state = Published(initialValue: initialState)
        
        // Create state stream
        createStateStream()
    }
    
    
    func mutate(_ action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .onAppear:
            if self.isFirstAppear {
                self.isFirstAppear = false
                
                // 웹소켓 스트림 구독
                listenToTickerDataStream()
            }
            
            // AllMarketTicker스트림 구독
            webSocketHelper.requestSubscribeToStream(streams: [.allMarketTickerChangesIn24h], mustDeliver: true)
            
            // 변경사항 확인
            checkUpdatedInformation()
            
        case .onDisappear, .enterBackground:
            webSocketHelper.requestUnsubscribeToStream(streams: [.allMarketTickerChangesIn24h], mustDeliver: false)
            
        case .getBackToForeground:
            webSocketHelper.requestSubscribeToStream(streams: [.allMarketTickerChangesIn24h], mustDeliver: true)
            
        case .coinRowIsTapped(let tickerCellRO):
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                listener?.request(.presentCoinDetailPage(
                    listener: self,
                    symbolInfo: .init(
                        firstSymbol: "",
                        secondSymbol: ""
                    )
                ))
            }
            
        default:
            break
        }
        return Just(action).eraseToAnyPublisher()
    }
    
    
    func reduce(_ action: Action, state: State) -> State {
        var newState = state
        switch action {
        case .tickerListFetched(let list):
            
            let currencyType = list.currencyType
            newState.tickerList = list
            newState.tickerCellRenderObjects = list.tickers
                .sorted(by: state.currentComparator.compare)
                .map { ticker in
                    createTickerCellRO(ticker, currencyType: currencyType)
                }
            
        case .sortSelectionButtonTapped(let selectedSortType):
            
            // 리스트 정렬 버튼(라디오 버튼) 업데이트
            newState.sortSelectionCells = state.sortSelectionCells.map { model in
                var newModel = model
                if model.sortType == selectedSortType {
                    newModel.sortDirection = model.sortDirection.nextDirectionOnTap()
                    return newModel
                } else {
                    newModel.sortDirection = .neutral
                    return newModel
                }
            }
            
            // 선택된 방법으로 리스트 정렬 상태 업데이트
            guard let selectedCell = state.sortSelectionCells.first(where: { $0.sortType == selectedSortType }) else { break }
            let nextDirection = selectedCell.sortDirection.nextDirectionOnTap()
            let comparator = selectedCell.sortType.getComparator(direction: nextDirection)
            newState.currentComparator = comparator
            
            if let prevList = newState.tickerList {
                let currencyType = prevList.currencyType
                newState.tickerCellRenderObjects = prevList.tickers
                    .sorted(by: comparator.compare)
                    .map { createTickerCellRO($0, currencyType: currencyType) }
            }
            
        case .updateSortSelectionButtons(let languageType, let currencyType):
            
            // #1. 가격정보 변경에 따른 티커 리스트 업데이트
            if let prev_currency_type = newState.tickerList?.currencyType {
                
                // 이전 화폐정보가 존재하는 경우
                if prev_currency_type != currencyType {
                    
                    // 이전 정보와 새로운 정보가 다른 경우, 리스트를 비움
                    newState.tickerCellRenderObjects = []
                }
            }
            
            
            // #2. 정렬 버튼 텍스트 업데이트
            newState.sortSelectionCells = state.sortSelectionCells.map { renderObject in
                let newText = createSortSelectionButtonText(
                    sortType: renderObject.sortType,
                    languageType: languageType,
                    currenyType: currencyType
                )
                var newObject = renderObject
                newObject.displayText = newText
                return newObject
            }
            
        case .updateGridType(let gridType):
            
            newState.tickerGridType = gridType
            
        default:
            return state
        }
        return newState
    }
    
    private func checkUpdatedInformation() {
        Task {
            let languageType = i18NManager.getLanguageType()
            let currencyType = i18NManager.getCurrencyType()
            let gridType = useCase.getGridType()
            
            action.send(.updateSortSelectionButtons(
                languageType: languageType,
                currenyType: currencyType
            ))
            action.send(.updateGridType(type: gridType))
        }
    }
}


// MARK: Public interface
extension AllMarketTickerViewModel {
    func action(_ action: Action) {
        self.action.send(action)
    }
}


// MARK: State & Action
extension AllMarketTickerViewModel {
    struct State {
        // Sort selection button
        var sortSelectionCells: [SortSelectionCellRO]
        fileprivate var currentComparator: TickerComparator = TickerNoneComparator()
        
        // Ticker cell
        fileprivate var tickerList: TickerList?
        let tickerRowCount: Int
        var tickerGridType: GridType = .list
        var tickerCellRenderObjects: [TickerCellRO] = []
        
        var isLoaded: Bool { !tickerCellRenderObjects.isEmpty }
        
        init(sortSelectionCells: [SortSelectionCellRO], tickerRowCount: Int) {
            self.sortSelectionCells = sortSelectionCells
            self.tickerRowCount = tickerRowCount
        }
    }
}


// MARK: Websocket stream subscription
private extension AllMarketTickerViewModel {
    func listenToTickerDataStream() {
        // 스트림 메시지 구독
        useCase
            .getTickerListStream(tickerCount: tickerRowCount)
            .throttle(for: 0.5, scheduler: DispatchQueue.global(), latest: true)
            .map { Action.tickerListFetched(list: $0) }
            .subscribe(action)
            .store(in: &store)
    }
}


// MARK: Create ticker cell render object
private extension AllMarketTickerViewModel {
    func createTickerCellRO(_ ticker: Ticker, currencyType: CurrencyType) -> TickerCellRO {
        let first_symbol = ticker.pairSymbol
            .uppercased()
            .replacingOccurrences(of: "USDT", with: "")
        let symbolImageURL = createSymbolImageURL(symbol: first_symbol)
        let priceText = createPriceText(ticker.price, currencyType: currencyType)
        let (cpText, cpTextColor) = createChangePercentTextConfig(ticker.changedPercent)
        return TickerCellRO(
            symbolText: ticker.pairSymbol.uppercased(),
            symbolImageURL: symbolImageURL,
            priceText: priceText,
            changePercentText: cpText,
            changePercentTextColor: cpTextColor
        )
    }
    
    func createSymbolImageURL(symbol: String) -> String {
        let baseURL = URL(string: "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/refs/heads/master/32/icon")!
        let symbolImageURL = baseURL.appendingPathComponent(symbol.lowercased(), conformingTo: .png)
        return symbolImageURL.absoluteString
    }
    
    func createChangePercentTextConfig(_ percent: Decimal) -> (String, Color) {
        let percentText = roundDecimal(percent, fractionLimit: 2)+"%"
        var displayText: String = percentText
        var displayColor: Color = .red
        if percent >= 0.0 {
            displayText = "+"+displayText
            displayColor = .green
        }
        return (displayText, displayColor)
    }
    
    func createPriceText(_ price: Decimal, currencyType: CurrencyType) -> String {
        let currency_symbol = currencyType.symbol
        let formatted_price_text = roundDecimal(price, fractionLimit: 2)
        
        var price_text: String
        if currencyType.isPrefix {
            price_text = "\(currency_symbol) \(formatted_price_text)"
        } else {
            price_text = "\(formatted_price_text) \(currency_symbol)"
        }
        return price_text
    }
}


// MARK: Decimal formatting
private extension AllMarketTickerViewModel {
    func roundDecimal(_ number: Decimal, fractionLimit: Int) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = fractionLimit
        formatter.minimumFractionDigits = fractionLimit
        formatter.roundingMode = .down
        let formattedString = formatter.string(from: number as NSDecimalNumber)
        return formattedString ?? "-1.0"
    }
}


// MARK: Create sort selection cell render objects
private extension AllMarketTickerViewModel {
    func createInitialSortSelectonROs() -> [SortSelectionCellRO] {
        SortSelectionCellType.orderedList.map { sortType in
            SortSelectionCellRO(sortType: sortType, sortDirection: .neutral)
        }
    }
}


// MARK: I18N
private extension AllMarketTickerViewModel {
    func createSortSelectionButtonText(sortType type: SortSelectionCellType, languageType: LanguageType, currenyType: CurrencyType) -> String {
        switch type {
        case .symbol:
            return localizedStrProvider.getString(
                key: .pageKey(page: .allMarketTicker(contents: .tableSymbolColumnTitle)),
                languageType: languageType
            )
        case .price:
            return localizedStrProvider.getString(
                key: .pageKey(page: .allMarketTicker(contents: .tablePriceColumnTitle)),
                languageType: languageType
            )+"(\(currenyType.symbol))"
        case .changeIn24h:
            return localizedStrProvider.getString(
                key: .pageKey(page: .allMarketTicker(contents: .table24hchangeColumnTitle)),
                languageType: languageType
            )
        }
    }
}


// MARK: CoinDetailPageListener
extension AllMarketTickerViewModel: CoinDetailPageListener {
    func request(_ request: CoinDetailPageListenerRequest) {
        switch request {
        case .closePage:
            listener?.request(.dismissCoinDetailPage)
        }
    }
}
