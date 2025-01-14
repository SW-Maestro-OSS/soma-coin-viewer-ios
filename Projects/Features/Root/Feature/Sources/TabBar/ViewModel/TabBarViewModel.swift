//
//  TabBarViewModel.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

import SwiftUI
import Combine

import BaseFeature
import SettingFeature

import DomainInterface

import I18N

import CoreUtil

class TabBarViewModel: UDFObservableObject, TabBarViewModelable {
    
    // Stream
    private let gridTypeChangePublisher: PassthroughSubject<GridType, Never>
    
    
    // DI
    @Injected private var i18NManager: I18NManager
    
    
    // State
    @Published var state: State
    
    var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = .init()
    private var isFirstAppear: Bool = true
    
    
    // Router
    @Published private var _router: WeakTabBarRouting = .init(nil)
    var router: TabBarRouting? {
        get { _router.value }
        set { _router = WeakTabBarRouting(newValue) }
    }
    
    
    init(gridTypeChangePublisher: PassthroughSubject<GridType, Never>) {
        
        self.gridTypeChangePublisher = gridTypeChangePublisher
        
        // Initial state
        self.state = .init(
            tabItem: [
                .allMarketTicker : .init(
                    titleKey: "AllMarketTickerPage_tabBar_market",
                    systemIconName: "24.square"
                ),
                .setting : .init(
                    titleKey: "AllMarketTickerPage_tabBar_setting",
                    systemIconName: "gear"
                ),
            ],
            languageType: .english
        )
        
        createStateStream()
    }
    
    func mutate(_ action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .onAppear:
            if isFirstAppear {
                isFirstAppear = false
                let languageType = i18NManager.getLanguageType()
                subscribeToI18NMutation()
                return Just(.applyLanguageType(languageType)).eraseToAnyPublisher()
            }
            break
        default:
            break
        }
        return Just(action).eraseToAnyPublisher()
    }
    
    func reduce(_ action: Action, state: State) -> State {
        var newState = state
        switch action {
        case .applyLanguageType(let languageType):
            newState.languageType = languageType
        default:
            return state
        }
        return newState
    }
}


// MARK: Private
private extension TabBarViewModel {
    
    func subscribeToI18NMutation() {
        i18NManager
            .getChangePublisher()
            .compactMap({ $0.languageType })
            .receive(on: RunLoop.main)
            .sink { [weak self] mutatedLanType in
                guard let self else { return }
                action.send(.applyLanguageType(mutatedLanType))
            }
            .store(in: &store)
    }
}


// MARK: Public interface
extension TabBarViewModel {
    
    func action(_ action: Action) {
        self.action.send(action)
    }
}


// MARK: Action & State
extension TabBarViewModel {
    
    struct State {
        var tabItem: [TabBarPage: TabItem]
        var languageType: LanguageType
    }
    
    enum Action {
        
        case onAppear
        case applyLanguageType(LanguageType)
    }
}


// MARK: SettingViewModelListenr
extension TabBarViewModel {
    
    func mutation(gridType: GridType) {
        gridTypeChangePublisher.send(gridType)
    }
}


private extension TabBarViewModel {
 
    class WeakTabBarRouting {
        
        weak var value: TabBarRouting?
        
        init(_ value: TabBarRouting?) {
            self.value = value
        }
    }
}
