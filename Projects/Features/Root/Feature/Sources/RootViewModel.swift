//
//  RootViewModel.swift
//  RootModule
//
//  Created by choijunios on 12/4/24.
//

import SwiftUI
import Combine

import BaseFeature

import DomainInterface

import CoreUtil
import I18N
import WebSocketManagementHelper

final class RootViewModel: UDFObservableObject, RootViewModelable {

    // DI
    private let i18NManager : I18NManager
    private let webSocketHelper: WebSocketManagementHelper
    private let exchangeRateUseCase: ExchangeRateUseCase
    
    
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
    
    
    init(i18NManager : I18NManager, webSocketHelper: WebSocketManagementHelper, exchangeRateUseCase: ExchangeRateUseCase) {
        
        self.i18NManager = i18NManager
        self.webSocketHelper = webSocketHelper
        self.exchangeRateUseCase = exchangeRateUseCase
        
        let initailState: State = .init(isLoading: true)
        self._state = Published(wrappedValue: initailState)
        
        // Create state stream
        createStateStream()
        
        // Subscribe to notifications
        setAppLifeCycleNotification()
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
            
        case .onAppear:
            
            if isFirstAppear {
                
                isFirstAppear = false
                
                // 웹소켓 연결
                webSocketHelper.requestConnection(connectionType: .freshStart)
                
                // 환율정보 Fetch
                exchangeRateUseCase.prepare()
            }
            
            return Just(.appIsLoaded)
                .delay(for: 2, scheduler: RunLoop.main)
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
        case .appIsLoaded:
            newState.isLoading = false
            router?.presentMainTabBar()
            
        default:
            return state
        }
        
        return newState
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
        case appIsLoaded
        
        // Side effects
        case isWebSocketConnected(Bool)
    }
    
    struct State {
        var isLoading: Bool
        var isWebSocketConnected: Bool?
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
