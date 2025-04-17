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
import CoreUtil
import I18N
import AlertShooter

public protocol AllMarketTickerRouting: AnyObject { }

public enum AllMarketTickerPageListenerRequest {
    case presentCoinDetailPage(listener: CoinDetailPageListener, symbolInfo: CoinSymbolInfo)
    case dismissCoinDetailPage
}

public protocol AllMarketTickerPageListener: AnyObject {
    func request(_ request: AllMarketTickerPageListenerRequest)
}

enum AllMarketTickerViewAction {
    
    // View event
    case onAppear
    case onDisappear
    case sortSelectionButtonTapped(type: SortSelectionCellType)
    case coinRowIsTapped(id: String)
    case enterBackground
    case getbackToForeground
    
    // Side effect
    case tickerListFetched(list: [Twenty4HourTickerForSymbolVO])
    
    
    // Configuration changed
    case i18NUpdated(
        languageType: LanguageType?=nil,
        currenyType: CurrencyType?=nil,
        exchangeRate: Double?=nil
    )
    case gridTypeUpdated(type: GridType)
}

final class AllMarketTickerViewModel: UDFObservableObject, AllMarketTickerViewModelable {
    
    // Dependency
    private let i18NManager: I18NManager
    private let languageLocalizationRepository: LanguageLocalizationRepository
    private let allMarketTickersUseCase: AllMarketTickersUseCase
    private let exchangeUseCase: ExchangeRateUseCase
    private let userConfigurationRepository: UserConfigurationRepository
    private let alertShooter: AlertShooter
    
    
    // Router
    weak var router: AllMarketTickerRouting?
    
    
    // Listener
    weak var listener: AllMarketTickerPageListener?
    
    
    // State
    @Published var state: State = .init()
    private var tickerCellVO: [Twenty4HourTickerForSymbolVO] = []
    private var isFirstAppear: Bool = true
    
    
    // Action
    typealias Action = AllMarketTickerViewAction
    var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    
    init(
        i18NManager: I18NManager,
        languageLocalizationRepository: LanguageLocalizationRepository,
        allMarketTickersUseCase: AllMarketTickersUseCase,
        exchangeUseCase: ExchangeRateUseCase,
        userConfigurationRepository: UserConfigurationRepository,
        alertShooter: AlertShooter
    ) {
        self.i18NManager = i18NManager
        self.languageLocalizationRepository = languageLocalizationRepository
        self.allMarketTickersUseCase = allMarketTickersUseCase
        self.exchangeUseCase = exchangeUseCase
        self.userConfigurationRepository = userConfigurationRepository
        self.alertShooter = alertShooter
        
        
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
        let currentState = self.state
        switch action {
        case .onAppear:
            if self.isFirstAppear {
                self.isFirstAppear = false
                // 웹소켓 스트림 구독
                listenToTickerDataStream()
                
                // 환율정보 가져오기
                getExchangeRate(base: .dollar, to: state.currencyType)
            }
            
            // AllMarketTicker스트림 구독
            allMarketTickersUseCase.connectToAllMarketTickerStream()
            
            // i18N 변경사항 확인
            // - 언어
            var actions: [AnyPublisher<Action, Never>] = []
            let changedLanType = i18NManager.getLanguageType()
            if currentState.languageType != changedLanType {
                actions.append(
                    Just(Action.i18NUpdated(
                        languageType: changedLanType
                    )).eraseToAnyPublisher()
                )
            }
            
            // - 화폐
            let changedCurrneyType = i18NManager.getCurrencyType()
            if currentState.currencyType != changedCurrneyType {
                actions.append(
                    exchangeUseCase
                        .getExchangeRate(base: .dollar, to: changedCurrneyType)
                        .map {
                            Action.i18NUpdated(
                                currenyType: changedCurrneyType,
                                exchangeRate: $0
                            )
                        }
                        .eraseToAnyPublisher()
                )
            }
            
            // UserConfiguration변경사항 확인
            // - GridType
            let changedGridType = userConfigurationRepository.getGridType()
            if currentState.tickerGridType != changedGridType {
                actions.append(
                    Just(Action.gridTypeUpdated(type: changedGridType)).eraseToAnyPublisher()
                )
            }
            
            if actions.isEmpty { break }
            
            return Publishers.MergeMany(actions).eraseToAnyPublisher()
        case .onDisappear, .enterBackground:
            allMarketTickersUseCase.disConnectToAllMarketTickerStream()
        case .getbackToForeground:
            allMarketTickersUseCase.connectToAllMarketTickerStream()
        case .tickerListFetched(let newList):
            self.tickerCellVO = newList
        case .coinRowIsTapped(let id):
            if let entity = tickerCellVO.first(where: { $0.pairSymbol.lowercased() == id.lowercased() }) {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    listener?.request(.presentCoinDetailPage(
                        listener: self,
                        symbolInfo: .init(
                            firstSymbol: entity.firstSymbol,
                            secondSymbol: entity.secondSymbol
                        )
                    ))
                }
            }
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
            guard let exchangeRate = state.exchangeRate else { break }
            newState.tickerCellRO = sortedTickerVOs.map {
                createRO($0, currencyConfig: .init(
                    type: state.currencyType,
                    rate: exchangeRate
                ))
            }
        case .i18NUpdated(let languageType, let currencyType, let exchangeRate):
            if let languageType {
                newState.languageType = languageType
            }
            if let currencyType {
                newState.currencyType = currencyType
            }
            if let exchangeRate {
                newState.exchangeRate = exchangeRate
            }
            
            // selection cell 변경
            state.sortSelectionCellROs.forEach { type, ro in
                var newRO = ro
                newRO.displayText = createSelectionCellLocalizedText(
                    type: type,
                    languageType: newState.languageType,
                    currenyType: newState.currencyType
                )
                newState.sortSelectionCellROs[type] = newRO
            }

            // ticker cell 변경
            guard let exchangeRate else { break }
            let currentComparator = state.sortComparator
            let sortedTickerVOs = tickerCellVO.sorted(by: currentComparator.compare)
            newState.tickerCellRO = sortedTickerVOs.map {
                createRO($0, currencyConfig: .init(
                    type: newState.currencyType,
                    rate: exchangeRate
                ))
            }
            
        case .gridTypeUpdated(let gridType):
            newState.tickerGridType = gridType
            
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
            let sortedTickerVOs = tickerCellVO.sorted(by: newSortComparator.compare)
            guard let exchangeRate = state.exchangeRate else { break }
            newState.tickerCellRO = sortedTickerVOs.map {
                createRO($0, currencyConfig: .init(
                    type: state.currencyType,
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
        var tickerGridType: GridType
        var tickerCellRO: [TickerCellRO] = []
        
        // Currency
        var languageType: LanguageType
        var currencyType: CurrencyType
        var exchangeRate: Double?
        

        var isLoaded: Bool {
            !tickerCellRO.isEmpty &&
            exchangeRate != nil
        }
        
        init(
            sortSelectionCellROs: [SortSelectionCellType: SortSelectionCellRO] = [:],
            sortComparator: TickerSortComparator=TickerNoneComparator(),
            tickerDisplayType: GridType = .list,
            tickerCellRO: [TickerCellRO] = [],
            languageType: LanguageType = .english,
            currencyType: CurrencyType = .dollar,
            exchangeRate: Double? = nil
        ) {
            self.sortSelectionCellROs = sortSelectionCellROs
            self.sortComparator = sortComparator
            self.tickerGridType = tickerDisplayType
            self.tickerCellRO = tickerCellRO
            self.languageType = languageType
            self.currencyType = currencyType
            self.exchangeRate = exchangeRate
        }
    }
}


// MARK: Websocket stream subscription
private extension AllMarketTickerViewModel {
    
    func listenToTickerDataStream() {
        // 스트림 메시지 구독
        allMarketTickersUseCase
            .requestTickers()
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


// MARK: I18N
private extension AllMarketTickerViewModel {
    func createSelectionCellLocalizedText(type: SortSelectionCellType, languageType: LanguageType, currenyType: CurrencyType) -> String {
        switch type {
        case .symbol:
            let localizedString = languageLocalizationRepository.getString(
                key: type.displayTextKey,
                lanCode: languageType.lanCode
            )
            return localizedString
        case .price:
            var localizedString = languageLocalizationRepository.getString(
                key: type.displayTextKey,
                lanCode: languageType.lanCode
            )
            localizedString = "\(localizedString)(\(currenyType.symbol))"
            return localizedString
        case .changeIn24h:
            let localizedString = languageLocalizationRepository.getString(
                key: type.displayTextKey,
                lanCode: languageType.lanCode
            )
            return localizedString
        }
    }
}


// MARK: Exchange rate
private extension AllMarketTickerViewModel {
    
    func getExchangeRate(base: CurrencyType, to: CurrencyType) {
        exchangeUseCase
            .getExchangeRate(base: base, to: to)
            .sink(receiveValue: { [weak self] rate in
                guard let self else { return }
                if let rate {
                    let action = Action.i18NUpdated(
                        currenyType: to,
                        exchangeRate: rate
                    )
                    self.action.send(action)
                } else { alertExchangeRateError(base: base, to: to) }
            })
            .store(in: &store)
    }
    
    func alertExchangeRateError(base: CurrencyType, to: CurrencyType) {
        var alertModel = AlertModel(
            titleKey: TextKey.Alert.Title.exchangeRateError.rawValue,
            messageKey: TextKey.Alert.Message.failedToGetExchangerate.rawValue
        )
        alertModel.add(action: .init(
            titleKey: TextKey.Alert.ActionTitle.retry.rawValue
        ) { [weak self] in
            guard let self else { return }
            getExchangeRate(base: base, to: to)
        })
        alertShooter.shoot(alertModel)
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
