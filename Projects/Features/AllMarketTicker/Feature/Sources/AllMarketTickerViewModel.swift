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
    case updateSortSelectionTap(languageType: LanguageType, currenyType: CurrencyType)
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
    @Published var state: State = .init(tickerRowCount: 0)
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
        
        let initialSortSelectionROs = createInitialSortSelectonROs()
        let initialState: State = .init(
            tickerRowCount: tickerRowCount,
            sortSelectionCellROs: initialSortSelectionROs,
            sortComparator: TickerNoneComparator()
        )
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
            let currentComparator = state.currentSortComparator
            newState.tickerCellRO = list.map {
                createRO($0, currencyConfig: .init(
                    type: exchangeRateInfo.currentType,
                    rate: exchangeRateInfo.rate
                ))
            }.sorted(by: currentComparator.compare)
        case .updateSortSelectionTap(let languageType, let currencyType):
            // selection cell 변경
            state.sortSelectionCellROs.forEach { type, ro in
                var newRO = ro
                newRO.displayText = createSelectionCellLocalizedText(
                    type: type,
                    languageType: languageType,
                    currenyType: currencyType
                )
                newState.sortSelectionCellROs[type] = newRO
            }
        case .updateGridType(let gridType):
            newState.tickerGridType = gridType
            
        case .sortSelectionButtonTapped(let selectedType):
            // #1. 정렬 탭 UI업데이트
            var newSelectionRO: SortSelectionCellRO!
            for (type, ro) in state.sortSelectionCellROs {
                if type == selectedType {
                    // 현재 터치된 타입과 해당 정렬 오브젝트가 일치하는 경우
                    newSelectionRO = ro
                    switch ro.sortState {
                    case .neutral:
                        // neutral --> descending
                        newSelectionRO.sortState = .descending
                    case .ascending:
                        // ascending --> descending
                        newSelectionRO.sortState = .descending
                    case .descending:
                        // descending --> ascending
                        newSelectionRO.sortState = .ascending
                    }
                    newState.sortSelectionCellROs[type] = newSelectionRO
                } else {
                    // 현재 터치된 정렬 오브젝트가 아닌 경우
                    var newSelectionRO = ro
                    newSelectionRO.sortState = .neutral
                    newState.sortSelectionCellROs[type] = newSelectionRO
                }
            }
            
            // #2. 티커 리스트 정렬
            var newSortComparator: TickerSortComparator
            switch newSelectionRO.sortState {
            case .neutral: fatalError()
            case .ascending:
                newSortComparator = selectedType.getSortComparator(type: .ascending)
            case .descending:
                newSortComparator = selectedType.getSortComparator(type: .descending)
            }
            newState.currentSortComparator = newSortComparator
            newState.tickerCellRO = state.tickerCellRO.sorted(by: newSortComparator.compare)
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
            
            action.send(.updateSortSelectionTap(
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
        // Sort
        fileprivate var sortSelectionCellROs: [SortSelectionCellType: SortSelectionCellRO] = [:]
        var displayingSortSelectionCellROs: [SortSelectionCellRO] {
            let order: [SortSelectionCellType] = [.symbol, .price, .changeIn24h]
            return order.compactMap({ sortSelectionCellROs[$0] })
        }
        var currentSortComparator: TickerSortComparator = TickerNoneComparator()
        
        // Ticker cell
        let tickerRowCount: UInt
        var tickerGridType: GridType = .list
        var tickerCellRO: [TickerCellRO] = []
        
        
        var isLoaded: Bool { !tickerCellRO.isEmpty }
        
        
        init(
            tickerRowCount: UInt,
            sortSelectionCellROs: [SortSelectionCellType: SortSelectionCellRO] = [:],
            sortComparator: TickerSortComparator=TickerNoneComparator()
        ) {
            self.tickerRowCount = tickerRowCount
            self.sortSelectionCellROs = sortSelectionCellROs
            self.currentSortComparator = sortComparator
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
            .receive(on: DispatchQueue.main)
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
    func createInitialSortSelectonROs() -> [SortSelectionCellType: SortSelectionCellRO] {
        var sortSelectionROs: [SortSelectionCellType: SortSelectionCellRO] = [:]
        sortSelectionROs[.symbol] = .init(type: .symbol, sortState: .neutral)
        sortSelectionROs[.price] = .init(type: .price, sortState: .neutral)
        sortSelectionROs[.changeIn24h] = .init(type: .changeIn24h, sortState: .neutral)
        return sortSelectionROs
    }
}


// MARK: I18N
private extension AllMarketTickerViewModel {
    func createSelectionCellLocalizedText(type: SortSelectionCellType, languageType: LanguageType, currenyType: CurrencyType) -> String {
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
