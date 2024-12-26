//
//  RootViewModel.swift
//  RootModule
//
//  Created by choijunios on 12/4/24.
//

import SwiftUI
import Combine

import BaseFeatureInterface

import CoreUtil
import I18NInterface
import WebSocketManagementHelperInterface

class RootViewModel: UDFObservableObject {
    
    @Injected private var webSocketHelper: WebSocketManagementHelper
    @Injected private var i18NManager : I18NManager
    
    
    // Public state interface
    @Published var state: State = .init()
    
    
    
    // Publishers
    public let action: PassthroughSubject<Action, Never> = .init()
    
    var store: Set<AnyCancellable> = .init()
    
    
    init() {
        
        // Create state stream
        createStateStream()
        
        // Subscribe to notifications
        setAppLifeCycleNotification()
        
        i18NManager.setExchangeRate()
    }
    
    
    
    func mutate(_ action: Action) -> AnyPublisher<Action, Never> {
        
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
                .map { _ in Action.isWebSocketConnected(true) }
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
                .map { _ in Action.isWebSocketConnected(false) }
                .eraseToAnyPublisher()
            
        default:
            return Just(action).eraseToAnyPublisher()
        }
    }
    
    
    func reduce(_ action: Action, state: State) -> State {
        
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
            .map { _ in Action.app_cycle_background }
            .subscribe(action)
            .store(in: &store)
        
        
        // Foreground 상태 집입 직전
        NotificationCenter
            .Publisher(center: .default, name: UIApplication.willEnterForegroundNotification)
            .map { _ in Action.app_cycle_will_foreground }
            .subscribe(action)
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
