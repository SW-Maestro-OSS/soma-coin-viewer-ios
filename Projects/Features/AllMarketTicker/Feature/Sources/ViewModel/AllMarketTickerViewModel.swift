//
//  AllMarketTickerViewModel.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/5/24.
//

import SwiftUI
import Combine

import BaseFeature

import WebSocketManagementHelperInterface
import DomainInterface
import CoreUtil

class AllMarketTickerViewModel: UDFObservableObject, TickerSortSelectorViewModelDelegate {
    
    // Service locator
    private let webSocketManagementHelper: WebSocketManagementHelper
    private let allMarketTickersUseCase: AllMarketTickersUseCase
    private let userConfigurationRepository: UserConfigurationRepository
    
    
    // Publishing state
    @Published var state: State
    
    
    // Sub ViewModel
    private(set) var sortCompartorViewModels: [TickerSortSelectorViewModel] = []
    
    
    var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    
    init(socketHelper: WebSocketManagementHelper, useCase: AllMarketTickersUseCase, userConfigurationRepository: UserConfigurationRepository) {
        
        self.webSocketManagementHelper = socketHelper
        self.allMarketTickersUseCase = useCase
        self.userConfigurationRepository = userConfigurationRepository
        
        
        // Initial configuration
        let tickerDisplayType = userConfigurationRepository.getGridType()
        
        let initialState: State = .init(
            tickerDisplayType: tickerDisplayType
        )
        self._state = Published(initialValue: initialState)
        
        
        // Create sort selection view models
        createTickerSortSelectorViewModels()
        
        
        // Create state stream
        createStateStream()
        
        
        // Subscribe to data stream
        subscribeToTickerDataStream()
    }
    
    func reduce(_ action: Action, state: State) -> State {
        
        switch action {
        case .changeSortingCriteria(let comparator):
            
            var newState = state
            
            newState.currentSortComparator = comparator
            
            let sortedTickerList = state.tickerList.sorted(by: comparator)
            
            newState.tickerList = sortedTickerList
            newState.tickerCellViewModels = sortedTickerList.map(TickerCellViewModel.init)
            
            return newState
            
        case .fetchList(let list):
            
            var newState = state
            
            let currentComparator = state.currentSortComparator
            
            let sortedTickerList = list.sorted(by: currentComparator)
            
            newState.tickerList = sortedTickerList
            newState.tickerCellViewModels = sortedTickerList.map(TickerCellViewModel.init)
            
            return newState
        }
    }
}

// MARK: State & Action
extension AllMarketTickerViewModel {
    
    struct State {
        
        // - 저장 프로퍼티
        var tickerList: [Twenty4HourTickerForSymbolVO] = []
        var tickerDisplayType: GridType
        
        var currentSortComparator: any TickerSortComparator = TickerNoneComparator()
        var tickerCellViewModels: [TickerCellViewModel] = []
        
        // - 연산 프로퍼티
        var isLoaded: Bool {
            !tickerCellViewModels.isEmpty
        }
    }
    
    enum Action {
        
        // Event
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


extension Array where Element == Twenty4HourTickerForSymbolVO {
    
    func sorted(by comparator: any TickerSortComparator) -> Self {
        
        self.sorted { lhs, rhs in
            
            comparator.compare(lhs: lhs, rhs: rhs)
        }
    }
}
