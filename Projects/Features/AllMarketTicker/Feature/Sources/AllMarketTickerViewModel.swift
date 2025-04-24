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
    case tickerListFetched(list: [Twenty4HourTickerForSymbolVO])
    case updateTickerList(list: [Twenty4HourTickerForSymbolVO], exchangeRateInfo: ExchangeRateInfo)
    case updateSortSelectionButtons(languageType: LanguageType, currenyType: CurrencyType)
    case updateGridType(type: GridType)
}

final class AllMarketTickerViewModel: UDFObservableObject, AllMarketTickerViewModelable {
    
    // Dependency
    private let useCase: AllMarketTickersUseCase
    private let i18NManager: I18NManager
    private let alertShooter: AlertShooter
    private let webSocketHelper: WebSocketManagementHelper
    
    
    // Router
    weak var router: AllMarketTickerRouting?
    
    
    // Listener
    weak var listener: AllMarketTickerPageListener?
    
    
    // State
    @Published var state: State = .init(sortSelectionCells: [], tickerRowCount: 0)
    private let tickerRowCount: UInt = 30
    private var isFirstAppear: Bool = true
    
    
    // Action
    typealias Action = AllMarketTickerAction
    var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    
    init(
        useCase: AllMarketTickersUseCase,
        i18NManager: I18NManager,
        alertShooter: AlertShooter,
        webSocketHelper: WebSocketManagementHelper
    ) {
        self.useCase = useCase
        self.i18NManager = i18NManager
        self.alertShooter = alertShooter
        self.webSocketHelper = webSocketHelper
        
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
            
        case .tickerListFetched(let newList):
            return Just(action)
                .unretainedOnly(self)
                .asyncTransform { vm in
                    let currentType = vm.i18NManager.getCurrencyType()
                    let rate = await vm.useCase.getExchangeRate(base: .dollar, to: currentType)
                    return Action.updateTickerList(
                        list: newList,
                        exchangeRateInfo: .init(currentType: currentType, rate: rate ?? 1.0))
                }
                .eraseToAnyPublisher()
            
        case .coinRowIsTapped(let tickerCellRO):
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                listener?.request(.presentCoinDetailPage(
                    listener: self,
                    symbolInfo: .init(
                        firstSymbol: tickerCellRO.firstSymbol,
                        secondSymbol: tickerCellRO.secondSymbol
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
        case .updateTickerList(let list, let exchangeRateInfo):
            newState.tickerCellRO = list.map {
                createRO($0, currencyConfig: .init(
                    type: exchangeRateInfo.currentType,
                    rate: exchangeRateInfo.rate
                ))
            }
            .sorted(by: state.currentComparator.compare)
            
        case .sortSelectionButtonTapped(let selectedSortType):
            // 정렬 버튼 업데이트
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
            // 리스트 업데이트
            guard let selectedCell = state.sortSelectionCells.first(where: { $0.sortType == selectedSortType }) else { break }
            let nextDirection = selectedCell.sortDirection.nextDirectionOnTap()
            let comparator = selectedCell.sortType.getComparator(direction: nextDirection)
            newState.currentComparator = comparator
            newState.tickerCellRO = state.tickerCellRO.sorted(by: comparator.compare)
            
        case .updateSortSelectionButtons(let languageType, let currencyType):
            // selection cell 변경
            newState.sortSelectionCells = state.sortSelectionCells.map { renderObject in
                let newText =  getSortSelectionButtonText(
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
            let tickerList = await useCase.getTickerList(rowCount: tickerRowCount)
            let exchangeRate = await useCase.getExchangeRate(base: .dollar, to: currencyType)
            action.send(.updateTickerList(
                list: tickerList,
                exchangeRateInfo: .init(currentType: currencyType, rate: exchangeRate ?? 1.0)
            ))
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
        let tickerRowCount: Int
        var tickerGridType: GridType = .list
        var tickerCellRO: [TickerCellRO] = []
        
        var isLoaded: Bool { !tickerCellRO.isEmpty }
        
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
            .getTickerList(rowCount: tickerRowCount)
            .throttle(for: 0.5, scheduler: DispatchQueue.global(), latest: true)
            .map { Action.tickerListFetched(list: $0) }
            .subscribe(action)
            .store(in: &store)
    }
}


// MARK: Create ticker cell render object
private extension AllMarketTickerViewModel {
    func createRO(_ vo: Twenty4HourTickerForSymbolVO, currencyConfig: CurrencyConfig) -> TickerCellRO {
        let symbolImageURL = createSymbolImageURL(symbol: vo.firstSymbol)
        let (changePercentText, changePercentColor) = createChangePercentTextConfig(percent: vo.changedPercent)
        let displayPriceText = createPriceText(
            price: vo.price,
            config: currencyConfig
        )
        return TickerCellRO(
            symbolText: vo.pairSymbol,
            symbolImageURL: symbolImageURL,
            displayPriceText: displayPriceText,
            displayChangePercentText: changePercentText,
            displayChangePercentTextColor: changePercentColor,
            symbolPair: vo.pairSymbol,
            price: vo.price,
            changedPercent: vo.changedPercent,
            firstSymbol: vo.firstSymbol,
            secondSymbol: vo.secondSymbol
        )
    }
    
    func createSymbolImageURL(symbol: String) -> String {
        let baseURL = URL(string: "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/refs/heads/master/32/icon")!
        let symbolImageURL = baseURL.appendingPathComponent(symbol.lowercased(), conformingTo: .png)
        return symbolImageURL.absoluteString
    }
    
    func createChangePercentTextConfig(percent: CVNumber) -> (String, Color) {
        let percentText = percent.roundToTwoDecimalPlaces()+"%"
        var displayText: String = percentText
        var displayColor: Color = .red
        if percent >= 0.0 {
            displayText = "+"+displayText
            displayColor = .green
        }
        return (displayText, displayColor)
    }
    
    struct CurrencyConfig {
        let type: CurrencyType
        let rate: Double
    }
    
    func createPriceText(price: CVNumber, config: CurrencyConfig) -> String {
        
        let currencyType = config.type
        let currencySymbol = currencyType.symbol
        let exchangeRate = config.rate
        
        let dollarPrice: Decimal = price.wrappedNumber
        let formattedPrice = CVNumber(dollarPrice * Decimal(exchangeRate))
        var priceText = formattedPrice.roundToTwoDecimalPlaces()
        
        if currencyType.isPrefix {
            priceText = "\(currencySymbol) \(priceText)"
        } else {
            priceText = "\(priceText) \(currencySymbol)"
        }
        
        return priceText
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
    func getSortSelectionButtonText(sortType type: SortSelectionCellType, languageType: LanguageType, currenyType: CurrencyType) -> String {
        switch type {
        case .symbol:
            let localizedString = LocalizedStringProvider.instance().getString(
                key: type.displayTextKey,
                lanCode: languageType.lanCode
            )
            return localizedString
        case .price:
            var localizedString = LocalizedStringProvider.instance().getString(
                key: type.displayTextKey,
                lanCode: languageType.lanCode
            )
            localizedString = "\(localizedString)(\(currenyType.symbol))"
            return localizedString
        case .changeIn24h:
            let localizedString = LocalizedStringProvider.instance().getString(
                key: type.displayTextKey,
                lanCode: languageType.lanCode
            )
            return localizedString
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
