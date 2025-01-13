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
import I18N
import WebSocketManagementHelper

final class RootViewModel: UDFObservableObject, RootViewModelable {

    // DI
    private let i18NManager : I18NManager
    private let webSocketHelper: WebSocketManagementHelper
    
    
    // Public state interface
    @Published var state: State = .init()
    
    
    // Router
    @Published var router: RootRouting?
    
    
    // Publishers
    public let action: PassthroughSubject<Action, Never> = .init()
    
    var store: Set<AnyCancellable> = .init()
    
    
    init(webSocketHelper: WebSocketManagementHelper, i18NManager : I18NManager) {
        
        self.webSocketHelper = webSocketHelper
        self.i18NManager = i18NManager
        
        // Create state stream
        createStateStream()
        
        // Subscribe to notifications
        setAppLifeCycleNotification()
        
        i18NManager.setExchangeRate()
    }
    
    
    func action(_ action: Action) {
        self.action.send(action)
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
        
        var newState = state
        
        switch action {
        case .isWebSocketConnected(let isConnected):
            
            newState.isWebSocketConnected = isConnected
            return newState
            
        case .onAppear:
            
            if state.isFirstAppear {
                
                // 첫번째 appear인 경우 메인 화면을 표시
                
                newState.isFirstAppear = false
                router?.presentMainTabBar()
            }
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


// MARK: Action & State
extension RootViewModel {
    
    enum Action {
        
        // Events
        case onAppear
        case app_cycle_background
        case app_cycle_will_foreground
        
        // Side effects
        case isWebSocketConnected(Bool)
    }
    
    struct State {
        var isWebSocketConnected: Bool?
        var isFirstAppear: Bool = true
    }
}
