//
//  AllMarketTickerViewModel.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/5/24.
//

import SwiftUI
import Combine

import BaseFeatureInterface
import WebSocketManagementHelperInterface
import DomainInterface
import CoreUtil

class AllMarketTickerViewModel: UDFObservableObject {
    
    // Service locator
    private var webSocketManagementHelper: WebSocketManagementHelper
    private var allMarketTickersUseCase: AllMarketTickersUseCase
    
    @Published var state: State
    
    var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    
    init(socketHelper: WebSocketManagementHelper, useCase: AllMarketTickersUseCase) {
        
        self.webSocketManagementHelper = socketHelper
        self.allMarketTickersUseCase = useCase
        
        let initialState: State = .init(
            sortCompartorViewModels: [
                
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
        )
        
        self._state = Published(initialValue: initialState)
        
        
        // Create state stream
        createStateStream()
        
        
        // Subscribe to sort selection events
        subscribeToSortSelectionEvent(viewModels: state.sortCompartorViewModels)
        
        
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
            newState.tickerListCellViewModels = sortedTickerList.map(TickerListCellViewModel.init)
            
            return newState
            
        case .fetchList(let list):
            
            var newState = state
            
            let currentComparator = state.currentSortComparator
            
            let sortedTickerList = list.sorted(by: currentComparator)
            
            newState.tickerList = sortedTickerList
            newState.tickerListCellViewModels = sortedTickerList.map(TickerListCellViewModel.init)
            
            return newState
        }
    }
    
    private func subscribeToSortSelectionEvent(viewModels: [TickerSortSelectorViewModel]) {
        
        let tapObservables = state.sortCompartorViewModels.map { viewModel in
            
            // 정렬기준 버튼 선택 이벤트
            viewModel.tap
        }
        
        let mergedTapObservablesPublishers = Publishers.MergeMany(tapObservables).share()
        
        // 정렬 버튼 UI에게 현재 선택된 정렬기준을 전파
        mergedTapObservablesPublishers
            .unretained(self)
            .sink { viewModel, comparator in
                
                viewModel.state.sortCompartorViewModels.forEach { sortViewModel in
                    
                    sortViewModel.action.send(.sortComparatorChangedOutside(
                        comparator: comparator
                    ))
                }
            }
            .store(in: &store)
        
        
        // 현재 선택된 정렬기준을 리스트에 적용하기 위해 액션으로 전달
        mergedTapObservablesPublishers
            .map { comparator in
                Action.changeSortingCriteria(comparator: comparator)
            }
            .subscribe(action)
            .store(in: &store)
    }
    
    private func subscribeToTickerDataStream() {
        
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
}

// MARK: State & Action
extension AllMarketTickerViewModel {
    
    struct State {
        
        // - 저장 프로퍼티
        var tickerList: [Twenty4HourTickerForSymbolVO] = []
        var currentSortComparator: any TickerSortComparator = TickerNoneComparator()
        
        public var tickerListCellViewModels: [TickerListCellViewModel] = []
        public var sortCompartorViewModels: [TickerSortSelectorViewModel]
        
        // - 연산 프로퍼티
        var isLoaded: Bool {
            !tickerListCellViewModels.isEmpty
        }
    }
    
    enum Action {
        
        // Event
        case changeSortingCriteria(comparator: any TickerSortComparator)
        case fetchList(list: [Twenty4HourTickerForSymbolVO])
    }
}


extension Array where Element == Twenty4HourTickerForSymbolVO {
    
    func sorted(by comparator: any TickerSortComparator) -> Self {
        
        self.sorted { lhs, rhs in
            
            comparator.compare(lhs: lhs, rhs: rhs)
        }
    }
}
