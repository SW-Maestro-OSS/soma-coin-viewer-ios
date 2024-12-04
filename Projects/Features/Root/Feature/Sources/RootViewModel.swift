//
//  RootViewModel.swift
//  RootModule
//
//  Created by choijunios on 12/4/24.
//

import SwiftUI
import Combine

import CoreUtil
import WebSocketManagementHelperInterface

class RootViewModel: ObservableObject {
    
    @Injected private var webSocketHelper: WebSocketManagementHelper
    
    
    // Public state interface
    @Published private(set) var state: State = .init()
    
    
    
    // Publishers
    public let action: PassthroughSubject<Action, Never> = .init()
    
    private var store: Set<AnyCancellable> = .init()
    
    
    init() {
        
        action
            .unretained(self)
            .flatMap { viewModel, action in
                
                // #1. Mutation for side effect
                
                return viewModel.mutate(action)
            }
            .receive(on: DispatchQueue.main)
            .unretained(self)
            .sink { viewModel, action in
                
                // #2. Update current state
                
                let currentState = viewModel.state
                
                viewModel.state = viewModel.reduce(action, state: currentState)
            }
            .store(in: &store)
        
        
        // Subscribe to notifications
        setAppLifeCycleNotification()
    }
    
    
    private func mutate(_ action: Action) -> AnyPublisher<Action, Never> {
        
        switch action {
        case .app_cycle_will_foreground:
            
            let publisher = PassthroughSubject<Bool, Never>()
                
            webSocketHelper
                .isWebSocketConnected
                .filter({ $0 })
                .subscribe(publisher)
                .store(in: &store)
            
            webSocketHelper
                .requestConnection(connectionType: .recoverPreviousStreams)
            
            return publisher
                .first()
                .map { _ in
                    return Action.isWebSocketConnected(true)
                }
                .eraseToAnyPublisher()
            
        case .app_cycle_background:
            
            let publisher = PassthroughSubject<Bool, Never>()
                
            webSocketHelper
                .isWebSocketConnected
                .filter({ !$0 })
                .subscribe(publisher)
                .store(in: &store)
            
            webSocketHelper
                .requestDisconnection()
            
            return publisher
                .first()
                .map { _ in
                    return Action.isWebSocketConnected(false)
                }
                .eraseToAnyPublisher()
            
        default:
            return Just(action).eraseToAnyPublisher()
        }
    }
    
    
    private func reduce(_ action: Action, state: State) -> State {
        
        switch action {
        case .isWebSocketConnected(let isConnected):
            
            var newState = state
            newState.isWebSocketConnected = isConnected
            
            return newState
            
        default:
            return state
        }
    }
    
    private func setAppLifeCycleNotification() {
        
        // Background 상태 진입
        NotificationCenter
            .Publisher(center: .default, name: UIApplication.didEnterBackgroundNotification)
            .unretained(self)
            .sink { viewModel, notification in
                
                // After background
                viewModel.action.send(.app_cycle_background)
            }
            .store(in: &store)
        
        
        // Foreground 상태 집입 직전
        NotificationCenter
            .Publisher(center: .default, name: UIApplication.willEnterForegroundNotification)
            .unretained(self)
            .sink { viewModel, notification in
                
                // Before foreground
                viewModel.action.send(.app_cycle_will_foreground)
            }
            .store(in: &store)
        
    }
}

extension RootViewModel {
    
    enum Action {
        
        // Events
        case app_cycle_background
        case app_cycle_will_foreground
        
        // Side effects
        case isWebSocketConnected(Bool)
    }
    
    struct State {
        var isWebSocketConnected: Bool?
    }
}
