//
//  TickerSortSelectorViewModel.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI
import Combine

import BaseFeatureInterface
import WebSocketManagementHelperInterface
import DomainInterface
import CoreUtil

class TickerSortSelectorViewModel: UDFViewModel {
    
    @Published var state: State
    
    private(set) var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    init(title: String, comparator: any TickerSortComparator, reverseComparator: any TickerSortComparator) {
        
        let initialState: State = .init(
            title: title,
            comparator: comparator,
            reverseComparator: reverseComparator
        )
        
        self._state = .init(initialValue: initialState)
        
        // Create state stream
        createStateStream()
    }
    
    func mutate(_ action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .sortComparatorChangedOutside(let comparator):
            
            let currentState = state
            let nextDirection = getNextDirectionFromOutsideSelection(currentState, comparator)
            
            return Just(Action.changeSortDirection(direction: nextDirection)).eraseToAnyPublisher()
            
        case .tap:
            
            let currentState = state
            
            var nextDirection: SortDirection = .unselected
            
            switch currentState.sortDirection {
            case .unselected:
                nextDirection = .descending
            case .ascending:
                nextDirection = .descending
            case .descending:
                nextDirection = .ascending
            }
            
            return Just(Action.changeSortDirection(direction: nextDirection)).eraseToAnyPublisher()
            
        default:
            return Just(action).eraseToAnyPublisher()
        }
    }
    
    func reduce(_ action: Action, state: State) -> State {
        
        switch action {
        case .changeSortDirection(let direction):
            
            var newState = state
            newState.sortDirection = direction
            
            return newState
            
        default:
            return state
        }
    }
    
    private func getNextDirectionFromOutsideSelection(_ state: State, _ comparator: any TickerSortComparator) -> SortDirection {
        
        switch comparator.id {
        case state.comparator.id:
            return .ascending
        case state.reverseComparator.id:
            return .descending
        default:
            return .unselected
        }
    }
}

extension TickerSortSelectorViewModel {
    
    enum Action {
        
        // Event
        case sortComparatorChangedOutside(comparator: any TickerSortComparator)
        case tap
        
        // SideEffect
        case changeSortDirection(direction: SortDirection)
    }
    
    struct State {
        
        var title: String
        let comparator: any TickerSortComparator
        let reverseComparator: any TickerSortComparator
        var sortDirection: SortDirection = .unselected
    }
    
    enum SortDirection {
        
        case unselected
        case ascending
        case descending
    }
}
