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
    
    
    // Publishing state
    @Published var state: State
    
    
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
        let tickerDisplayType = userConfigurationRepository.getGridType()
        
        let initialState: State = .init(
            sortComparator: TickerNoneComparator(),
            tickerDisplayType: tickerDisplayType,
            currencyType: nil,
            exchangeRate: nil
        )
        self._state = Published(initialValue: initialState)
        
        
        // Create sort selection view models
        createTickerSortSelectorViewModels()
        
        
        // Create state stream
        createStateStream()
        
        
        // Subscribe to data stream
        subscribeToTickerDataStream()
        
        
        // Get currency type
        let currencyType: CurrencyType = i18NManager.getCurrencyType()
        exchangeUseCase
            .getExchangeRate(base: .dollar, to: currencyType)
            .sink { [weak self] rate in
                self?.action.send(.currencyTypeUpdated(type: currencyType, rate: rate))
            }
            .store(in: &store)
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
            
        case .currencyTypeUpdated(let type, let rate):
            
            newState.currencyType = type
            newState.exchangeRate = rate
            
        default:
            return state
        }
        return newState
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
        var currencyType: CurrencyType?
        var exchangeRate: Double?
        
        
        var isLoaded: Bool {
            !tickerCellViewModels.isEmpty && currencyType != nil && exchangeRate != nil
        }
    }
    
    enum Action {
        
        // Event
        case currencyTypeUpdated(type: CurrencyType, rate: Double)
        case changeSortingCriteria(comparator: any TickerSortComparator)
        case fetchList(list: [Twenty4HourTickerForSymbolVO])
    }
}


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
        
        let viewModels = [
            
            TickerSortSelectorViewModel(
                id: "symbol_sort",
                title: "Symbol",
                ascendingComparator: TickerSymbolAscendingComparator(),
                descendingComparator: TickerSymbolDescendingComparator()
            ),
            
            TickerSortSelectorViewModel(
                id: "price_sort",
                title: "Price($)",
                ascendingComparator: TickerPriceAscendingComparator(),
                descendingComparator: TickerPriceDescendingComparator()
            ),
            
            TickerSortSelectorViewModel(
                id: "24hchange_sort",
                title: "24h Changes(%)",
                ascendingComparator: Ticker24hChangeAscendingComparator(),
                descendingComparator: Ticker24hChangeDescendingComparator()
            )
        ]
        
        viewModels.forEach { viewModel in
            
            viewModel.delegate = self
        }
        
        self.sortCompartorViewModels = viewModels
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

