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

final class AllMarketTickerViewModel: UDFObservableObject, TickerSortSelectorViewModelDelegate, AllMarketTickerViewModelable {
    
    // DI
    private let webSocketManagementHelper: WebSocketManagementHelper
    private let i18NManager: I18NManager
    private let allMarketTickersUseCase: AllMarketTickersUseCase
    private let exchangeUseCase: ExchangeRateUseCase
    private let userConfigurationRepository: UserConfigurationRepository
    
    
    // State
    @Published var state: State
    private var isFirstAppear: Bool = true
    
    
    // Sub ViewModel
    private(set) var sortCompartorViewModels: [TickerSortSelectorViewModel] = []
    
    
    var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    
    init(
        socketHelper: WebSocketManagementHelper,
        i18NManager: I18NManager,
        allMarketTickersUseCase: AllMarketTickersUseCase,
        exchangeUseCase: ExchangeRateUseCase,
        userConfigurationRepository: UserConfigurationRepository
    ) {
        
        self.webSocketManagementHelper = socketHelper
        self.i18NManager = i18NManager
        self.allMarketTickersUseCase = allMarketTickersUseCase
        self.exchangeUseCase = exchangeUseCase
        self.userConfigurationRepository = userConfigurationRepository
        
        
        // Initial configuration
        let initialTickerDisplayType = userConfigurationRepository.getGridType()
        let initialLanguageType = i18NManager.getLanguageType()
        let initialCurrencyType = i18NManager.getCurrencyType()
        let initialState: State = .init(
            sortComparator: TickerNoneComparator(),
            tickerDisplayType: initialTickerDisplayType,
            languageType: initialLanguageType,
            currencyType: initialCurrencyType
        )
        self._state = Published(initialValue: initialState)
        
        
        // Create sort selection view models
        createTickerSortSelectorViewModels()
        
        
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
        case .changeSortingCriteria(let comparator):
            
            let sortedTickerViewModels = state.tickerCellViewModels.sorted(by: comparator)
            newState.tickerCellViewModels = sortedTickerViewModels
            newState.sortComparator = comparator
            
        case .fetchList(let list):
            
            let currentComparator = state.sortComparator
            let tickerViewModels = list.map { tickerVO in
                TickerCellViewModel(config: .init(
                    tickerVO: tickerVO,
                    currencyConfig: .init(
                        type: state.currencyType ?? .dollar,
                        rate: state.exchangeRate ?? 0.0
                    )
                ))
            }
            let sortedTickerViewModels = tickerViewModels.sorted(by: currentComparator)
            newState.tickerCellViewModels = sortedTickerViewModels
            
        case .currencyTypeUpdated(let currenyType, let rate):
            newState.currencyType = currenyType
            newState.exchangeRate = rate
            
        case .languageTypeUpdated(let languageType):
            newState.languageType = languageType
            
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
        var sortComparator: any TickerSortComparator
        
        // Cell
        var tickerDisplayType: GridType
        var tickerCellViewModels: [TickerCellViewModel] = []
        
        // Currency
        var languageType: LanguageType?
        var currencyType: CurrencyType?
        var exchangeRate: Double?
        
        
        var isLoaded: Bool {
            !tickerCellViewModels.isEmpty &&
            languageType != nil &&
            currencyType != nil &&
            exchangeRate != nil
        }
    }
    
    enum Action {
        
        // Event
        case onAppear
        case currencyTypeUpdated(type: CurrencyType, rate: Double)
        case languageTypeUpdated(type: LanguageType)
        case changeSortingCriteria(comparator: any TickerSortComparator)
        case fetchList(list: [Twenty4HourTickerForSymbolVO])
    }
}


// MARK: Private
private extension AllMarketTickerViewModel {
    
    func subscribeToTickerDataStream() {
        
        allMarketTickersUseCase
            .requestTickers()
            .map { tickers in
                
                return Action.fetchList(list: tickers)
            }
            .subscribe(action)
            .store(in: &store)
        
        
        // Subscribe to webSocketStream
        webSocketManagementHelper.requestSubscribeToStream(streams: ["!ticker@arr"])
    }
    
    func createTickerSortSelectorViewModels() {
        
        let tickerSortSelectorViewModels = [
            SymbolSortingViewModel(),
            PriceSortingViewModel(),
            ChangeIn24hViewModel()
        ]
        tickerSortSelectorViewModels.forEach { $0.delegate = self }
        self.sortCompartorViewModels = tickerSortSelectorViewModels
    }
    
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


// MARK: TickerSortSelectorViewModelDelegate
extension AllMarketTickerViewModel {
    
    func sortSelector(selection comparator: any TickerSortComparator) {
        
        // 정렬 버튼 UI에게 현재 선택된 정렬기준을 전파
        sortCompartorViewModels.forEach { sortViewModel in

            sortViewModel.notifySelectedComparator(comparator)
        }
        
        // 현재 선택된 정렬기준을 리스트에 적용하기 위해 액션으로 전달
        action.send(.changeSortingCriteria(comparator: comparator))
    }
}


// MARK: Array + Extension
extension Array where Element == TickerCellViewModel {
    
    func sorted(by comparator: any TickerSortComparator) -> Self {
        
        self.sorted { lhs, rhs in
            
            comparator.compare(lhs: lhs.tickerVO, rhs: rhs.tickerVO)
        }
    }
}

