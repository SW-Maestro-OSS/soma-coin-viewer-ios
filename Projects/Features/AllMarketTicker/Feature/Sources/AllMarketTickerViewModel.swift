//
//  AllMarketTickerViewModel.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/5/24.
//

import SwiftUI
import Combine

import DomainInterface
import WebSocketManagementHelperInterface
import DomainInterface
import CoreUtil

import BaseFeatureInterface

class AllMarketTickerViewModel: UDFObservableObject {
    
    // Service locator
    @Injected private var webSocketManagementHelper: WebSocketManagementHelper
    @Injected private var allMarketTickersUseCase: AllMarketTickersUseCase
    
    @Published var state: State = .init()
    
    var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
     
    init() {
        
        // Create state stream
        createStateStream()
        
        
        // Subscribe to data stream
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
    
    func reduce(_ action: Action, state: State) -> State {
        
        switch action {
        case .changeSortingCriteria(let comparator):
            
            var newState = state
            
            newState.currentSortComparator = comparator
            newState.tickerList = state.tickerList.sorted(by: comparator)
            
            return newState
            
        case .fetchList(let list):
            
            var newState = state
            
            let currentComparator = state.currentSortComparator
            
            if let currentComparator {
                
                newState.tickerList = list.sorted(by: currentComparator)
                
            } else {
                
                newState.tickerList = list
            }
            
            return newState
        }
    }
}

// MARK: State & Action
extension AllMarketTickerViewModel {
    
    struct State {
        // - 저장 프로퍼티
        var tickerList: [Twenty4HourTickerForSymbolVO] = []
        var currentSortComparator: (any TickerSortComparator)? = nil
        
        // - 연산 프로퍼티
        var isLoaded: Bool {
            !tickerList.isEmpty
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
