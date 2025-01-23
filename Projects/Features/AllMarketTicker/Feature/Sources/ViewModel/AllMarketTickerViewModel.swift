//
//  AllMarketTickerViewModel.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/5/24.
//

import SwiftUI
import Combine

import BaseFeature

import WebSocketManagementHelper
import DomainInterface
import CoreUtil
import I18N

final class AllMarketTickerViewModel: UDFObservableObject, AllMarketTickerViewModelable {
    
    // Stream
    private let gridTypeChangePublisher: AnyPublisher<GridType, Never>
    
    
    // DI
    private let webSocketManagementHelper: WebSocketManagementHelper
    private let i18NManager: I18NManager
    private let allMarketTickersUseCase: AllMarketTickersUseCase
    private let exchangeUseCase: ExchangeRateUseCase
    private let userConfigurationRepository: UserConfigurationRepository
    
    
    // State
    @Published var state: State = .init(tickerDisplayType: .list)
    private var isFirstAppear: Bool = true
    
    
    var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    
    init(
        gridTypeChangePublisher: AnyPublisher<GridType, Never>,
        socketHelper: WebSocketManagementHelper,
        i18NManager: I18NManager,
        allMarketTickersUseCase: AllMarketTickersUseCase,
        exchangeUseCase: ExchangeRateUseCase,
        userConfigurationRepository: UserConfigurationRepository
    ) {
       
        self.gridTypeChangePublisher = gridTypeChangePublisher
        self.webSocketManagementHelper = socketHelper
        self.i18NManager = i18NManager
        self.allMarketTickersUseCase = allMarketTickersUseCase
        self.exchangeUseCase = exchangeUseCase
        self.userConfigurationRepository = userConfigurationRepository
        
        
        // Initial configuration
        let initialTickerDisplayType = userConfigurationRepository.getGridType()
        let initialLanguageType = i18NManager.getLanguageType()
        let initialCurrencyType = i18NManager.getCurrencyType()
        let initialSortSelectionROs = createInitialSortSelectonROs()
        
        let initialState: State = .init(
            sortSelectionCellROs: initialSortSelectionROs,
            sortComparator: TickerNoneComparator(),
            tickerDisplayType: initialTickerDisplayType,
            languageType: initialLanguageType,
            currencyType: initialCurrencyType
        )
        self._state = Published(initialValue: initialState)
        
        
        // Create state stream
        createStateStream()
    }
    
    
    func mutate(_ action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .onAppear:
            let currentState = self.state
            if self.isFirstAppear {
                self.isFirstAppear = false
                
                // AllMarketTicker스트림 구독
                subscribeToTickerDataStream()
                
                // I18N 스트림 구독
                subscribeToI18NMutation()
                
                // GridType변경 구독
                subscribeToGridTypeChange()
                
                // 환율정보 가져오기
                if let currencyType = currentState.currencyType {
                    return exchangeUseCase
                        .getExchangeRate(base: .dollar, to: currencyType)
                        .map { Action.currencyTypeUpdated(type: currencyType, rate: $0) }
                        .eraseToAnyPublisher()
                }
                break
            }
            break
            
        default:
            break
        }
        return Just(action).eraseToAnyPublisher()
    }
    
    
    func reduce(_ action: Action, state: State) -> State {
        
        var newState = state
        
        switch action {
        case .tickerListFetched(let tickerVOs):
            
            let currentComparator = state.sortComparator
            let sortedTickerVOs = tickerVOs.sorted(by: currentComparator.compare)
            guard let currencyType = state.currencyType, let exchangeRate = state.exchangeRate else { break }
            newState.tickerCellVO = sortedTickerVOs
            newState.tickerCellRO = sortedTickerVOs.map {
                createRO($0, currencyConfig: .init(
                    type: currencyType,
                    rate: exchangeRate
                ))
            }
        case .currencyTypeUpdated(let currenyType, let rate):
            newState.currencyType = currenyType
            newState.exchangeRate = rate
            
        case .languageTypeUpdated(let languageType):
            newState.languageType = languageType
            
        case .gridTypeUpdated(let gridType):
            newState.tickerDisplayType = gridType
            
        case .sortSelectionButtonTapped(let selectedType):
            // #1. UI update
            var newSelectionRO: SortSelectionCellRO!
            state.sortSelectionCellROs.forEach { type, ro in
                if type == selectedType {
                    // 선택된 타입인 경우
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
                    // 선택되지 않은 타입인 경우
                    var newSelectionRO = ro
                    newSelectionRO.sortState = .neutral
                    newState.sortSelectionCellROs[type] = newSelectionRO
                }
            }
            
            // #2. Sort current
            var newSortComparator: TickerSortComparator!
            switch newSelectionRO.sortState {
            case .neutral:
                fatalError()
            case .ascending:
                newSortComparator = selectedType.getSortComparator(type: .ascending)
            case .descending:
                newSortComparator = selectedType.getSortComparator(type: .descending)
            }
            newState.sortComparator = newSortComparator
            let sortedTickerVOs = state.tickerCellVO.sorted(by: newSortComparator.compare)
            guard let currencyType = state.currencyType, let exchangeRate = state.exchangeRate else { break }
            newState.tickerCellRO = sortedTickerVOs.map {
                createRO($0, currencyConfig: .init(
                    type: currencyType,
                    rate: exchangeRate
                ))
            }
            
        default:
            return state
        }
        return newState
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
        var sortComparator: TickerSortComparator = TickerNoneComparator()
        var displayingSortSelectionCellROs: [SortSelectionCellRO] {
            let order: [SortSelectionCellType] = [.symbol, .price, .changeIn24h]
            return order.compactMap({ sortSelectionCellROs[$0] })
        }
        
        // Ticker cell
        fileprivate var tickerCellVO: [Twenty4HourTickerForSymbolVO] = []
        var tickerDisplayType: GridType
        var tickerCellRO: [TickerCellRO] = []
        
        // Currency
        var languageType: LanguageType?
        var currencyType: CurrencyType?
        var exchangeRate: Double?
        
        
        var isLoaded: Bool {
            !tickerCellRO.isEmpty &&
            languageType != nil &&
            currencyType != nil &&
            exchangeRate != nil
        }
    }
    
    enum Action {
        
        // View event
        case onAppear
        case sortSelectionButtonTapped(type: SortSelectionCellType)
        
        
        // Side effect
        case tickerListFetched(list: [Twenty4HourTickerForSymbolVO])
        
        
        // Configuration changed
        case gridTypeUpdated(type: GridType)
        case currencyTypeUpdated(type: CurrencyType, rate: Double)
        case languageTypeUpdated(type: LanguageType)
    }
}


// MARK: Websocket stream subscription
private extension AllMarketTickerViewModel {
    
    func subscribeToTickerDataStream() {
        
        allMarketTickersUseCase
            .requestTickers()
            .map { Action.tickerListFetched(list: $0) }
            .subscribe(action)
            .store(in: &store)
        
        
        // Subscribe to webSocketStream
        webSocketManagementHelper.requestSubscribeToStream(streams: ["!ticker@arr"])
    }
}


// MARK: I18N stream subscription
private extension AllMarketTickerViewModel {
    
    func subscribeToI18NMutation() {
        
        // MARK: 화폐정보변경
        i18NManager
            .getChangePublisher()
            .receive(on: RunLoop.main)
            .compactMap({ $0.currencyType })
            .unretained(self)
            .flatMap { vm, mutatedCurrencyType in
                
                // NOTE: currencyType의 경우 즉시 환율 정보를 가져오도록 한다.
                
                vm.exchangeUseCase
                    .getExchangeRate(base: .dollar, to: mutatedCurrencyType)
                    .map({ (mutatedCurrencyType, $0) })
            }
            .sink { [weak self] currencyType, rate in
                guard let self else { return }
                action.send(.currencyTypeUpdated(type: currencyType, rate: rate))
            }
            .store(in: &store)
        
        
        // MARK: 언어정보 변경
        i18NManager
            .getChangePublisher()
            .receive(on: RunLoop.main)
            .compactMap({ $0.languageType })
            .sink { [weak self] mutatedLanguage in
                guard let self else { return }
                action.send(.languageTypeUpdated(type: mutatedLanguage))
            }
            .store(in: &store)
    }
}


// MARK: User configuarion changes
private extension AllMarketTickerViewModel {
    
    func subscribeToGridTypeChange() {
        
        gridTypeChangePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] gridType in
                guard let self else { return }
                action.send(.gridTypeUpdated(type: gridType))
            }
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
            displayChangePercentTextColor: changePercentColor
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
