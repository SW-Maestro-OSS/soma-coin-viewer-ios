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

class TickerSortSelectorViewModel: Identifiable, UDFObservableObject {
    
    let id: String
    
    @Published var state: State
    
    private let ascendingComparator: any TickerSortComparator
    private let descendingComparator: any TickerSortComparator
    
    // Ouside case
    let tap: PassthroughSubject<any TickerSortComparator, Never> = .init()
    
    private(set) var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    
    init(id: String, title: String, ascendingComparator: any TickerSortComparator, descendingComparator: any TickerSortComparator) {
        
        self.id = id
        self.ascendingComparator = ascendingComparator
        self.descendingComparator = descendingComparator
        
        let initialState: State = .init(
            sortDirection: .unselected,
            title: title
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
            
            
            // 선택사항을 외부로 전달
            tap.send(nextDirection == .ascending ? ascendingComparator : descendingComparator)
            
            
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
        case ascendingComparator.id:
            return .ascending
        case descendingComparator.id:
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
        
        // - 저장 프로퍼티
        fileprivate var sortDirection: SortDirection = .unselected
        
        public var title: String
        
        // - 연산 프로퍼티
        public var imageName: String {
            
            switch sortDirection {
            case .unselected:
                "chevron.up.chevron.down"
            case .ascending:
                "arrowtriangle.up.fill"
            case .descending:
                "arrowtriangle.down.fill"
            }
        }
    }
    
    enum SortDirection {
        
        case unselected
        case ascending
        case descending
    }
}
