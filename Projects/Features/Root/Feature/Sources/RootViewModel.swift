//
//  RootViewModel.swift
//  RootModule
//
//  Created by choijunios on 12/4/24.
//

import SwiftUI
import Combine

import BaseFeature

import CoreUtil

final class RootViewModel: UDFObservableObject, RootViewModelable {

    // Public state interface
    @Published var state: State
    
    
    // Router
    @Published private var _router: WeakRootRouting = .init(nil)
    var router: RootRouting? {
        get { self._router.value }
        set { self._router = WeakRootRouting(newValue) }
    }
    
    
    // State
    private var isFirstAppear: Bool = true
    
    
    // Publishers
    let action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = .init()
    
    
    init() {
        
        let initailState: State = .init(isLoading: true)
        self._state = Published(wrappedValue: initailState)
        
        // Create state stream
        createStateStream()
    }
    
    
    func action(_ action: Action) {
        self.action.send(action)
    }
    
    
    func mutate(_ action: Action) -> AnyPublisher<Action, Never> {
        
        switch action {
        case .onAppear:
            
            if isFirstAppear {
                isFirstAppear = false
                
                // 화면 최초 등장시 2초간의 지연 발생
                return Just(.appIsLoaded)
                    .delay(for: 2, scheduler: RunLoop.main)
                    .eraseToAnyPublisher()
            }
            
        default:
            break
        }
        return Just(action).eraseToAnyPublisher()
    }
    
    
    func reduce(_ action: Action, state: State) -> State {
        
        var newState = state
        switch action {
        case .appIsLoaded:
            newState.isLoading = false
            router?.presentMainTabBar()
        default:
            return state
        }
        
        return newState
    }
}


// MARK: Action & State
extension RootViewModel {
    
    enum Action {
        // Events
        case onAppear
        case appIsLoaded
    }
    
    struct State {
        var isLoading: Bool
    }
}


// MARK: WeakRootRouting
private extension RootViewModel {
    
    class WeakRootRouting {
        
        weak var value: RootRouting?
        
        init(_ value: RootRouting?) {
            self.value = value
        }
    }
}
