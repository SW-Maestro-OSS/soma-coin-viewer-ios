//
//  TabBarViewModel.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

import SwiftUI
import Combine

import BaseFeature

import DomainInterface

import I18N
import CoreUtil

class TabBarViewModel: UDFObservableObject, TabBarViewModelable {

    private let i18NManager: I18NManager
    private let languageRepository: LanguageLocalizationRepository
    
    
    // State
    @Published var state: State = .init(tabItemROs: [], languageType: .english)
    
    var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = .init()
    private var isFirstAppear: Bool = true
    
    
    // Router
    @Published private var _router: WeakTabBarRouting = .init(nil)
    var router: TabBarRouting? {
        get { _router.value }
        set { _router = WeakTabBarRouting(newValue) }
    }
    
    
    init(i18NManager: I18NManager, languageRepository: LanguageLocalizationRepository) {
        
        self.i18NManager = i18NManager
        self.languageRepository = languageRepository
        
        // Initial state
        let languageType = i18NManager.getLanguageType()
        let tabItemROs = createTabBarItemROs(languageType: languageType)
        let initialState: State = .init(
            tabItemROs: tabItemROs,
            languageType: languageType
        )
        self.state = initialState
        
        createStateStream()
    }
    
    func mutate(_ action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .onAppear:
            if isFirstAppear {
                isFirstAppear = false
                let languageType = i18NManager.getLanguageType()
                subscribeToI18NMutation()
                return Just(.languageTypeUpdated(languageType)).eraseToAnyPublisher()
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
        case .languageTypeUpdated(let languageType):
            newState.languageType = languageType
            let newTabBarROs = createTabBarItemROs(languageType: languageType)
            newState.tabItemROs = newTabBarROs
        default:
            return state
        }
        return newState
    }
}


// MARK: Tab bar item creation & modification
private extension TabBarViewModel {
    
    func createTabBarItemROs(languageType: LanguageType) -> [TabBarItemRO] {
        let orderedPage: [TabBarPage] = [.allMarketTicker, .setting]
        return orderedPage.map { page in
            
            let displayText = languageRepository.getString(
                key: page.titleTextLocalizationKey,
                lanCode: languageType.lanCode
            )
            
            return TabBarItemRO(
                page: page,
                displayText: displayText,
                displayIconName: page.systemIconName
            )
        }
    }
}


// MARK: Stream subscription
private extension TabBarViewModel {
    
    func subscribeToI18NMutation() {
        i18NManager
            .getChangePublisher()
            .compactMap({ $0.languageType })
            .receive(on: RunLoop.main)
            .sink { [weak self] mutatedLanType in
                guard let self else { return }
                action.send(.languageTypeUpdated(mutatedLanType))
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
        var tabItemROs: [TabBarItemRO]
        var languageType: LanguageType
    }
    
    enum Action {
        
        case onAppear
        case languageTypeUpdated(LanguageType)
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
