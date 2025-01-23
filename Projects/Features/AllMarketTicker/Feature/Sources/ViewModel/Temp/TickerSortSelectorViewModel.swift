//
//  TickerSortSelectorViewModel.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI
import Combine

import BaseFeature

import WebSocketManagementHelper
import DomainInterface
import CoreUtil

class TickerSortSelectorViewModel: Identifiable, UDFObservableObject {
    
    // Identifiable
    let id: UUID = .init()
    
    
    // State
    @Published var state: State
    private let config: Configuration
    private let ascendingComparator: TickerSortComparator
    private let descendingComparator: TickerSortComparator
    
    
    // Delegate
    weak var delegate: TickerSortSelectorViewModelDelegate?
    
    
    // Event
    private(set) var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    
    init(config: Configuration) {
        
        self.config = config
        self.ascendingComparator = config.ascending
        self.descendingComparator = config.descending
        
        
        // Initial state
        let initialState: State = .init(
            sortDirection: .unselected,
            title: config.intialTitleText
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
            let selectedComparator = getComparator(nextDirection)
            delegate?.sortSelector(selection: selectedComparator)
            
            
            return Just(Action.changeSortDirection(direction: nextDirection)).eraseToAnyPublisher()
            
        default:
            return Just(action).eraseToAnyPublisher()
        }
    }
    
    
    func reduce(_ action: Action, state: State) -> State {
        
        var newState = state
        switch action {
        case .changeSortDirection(let direction):
            newState.sortDirection = direction
        case .changeTitleText(let text):
            newState.title = text
        default:
            return state
        }
        return newState
    }
    
    func notifySelectedComparator(_ comparator: any TickerSortComparator) {
        action.send(.sortComparatorChangedOutside(comparator: comparator))
    }
}


// MARK: Action & State
extension TickerSortSelectorViewModel {
    
    enum Action {
        
        // Event
        case sortComparatorChangedOutside(comparator: any TickerSortComparator)
        case tap
        
        // SideEffect
        case changeSortDirection(direction: SortDirection)
        case changeTitleText(String)
    }
    
    struct State {
        
        var sortDirection: SortDirection = .unselected
        var title: String
        
        var isLoading: Bool { title.isEmpty }
        var imageName: String {
            
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


// MARK: Configuration
extension TickerSortSelectorViewModel {
    
    struct Configuration {
        let intialTitleText: String
        let ascending: TickerSortComparator
        let descending: TickerSortComparator
    }
}


private extension TickerSortSelectorViewModel {
    
    func getNextDirectionFromOutsideSelection(_ state: State, _ comparator: any TickerSortComparator) -> SortDirection {
        
        switch comparator.id {
        case ascendingComparator.id:
            return .ascending
        case descendingComparator.id:
            return .descending
        default:
            return .unselected
        }
    }
    
    func getComparator(_ direction: SortDirection) -> TickerSortComparator {
        
        return direction == .ascending ? ascendingComparator : descendingComparator
    }
}
