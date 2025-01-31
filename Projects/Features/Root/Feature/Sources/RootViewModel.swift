//
//  RootViewModel.swift
//  RootModule
//
//  Created by choijunios on 12/4/24.
//

import SwiftUI
import Combine

import DomainInterface

import BaseFeature

import I18N
import CoreUtil

final class RootViewModel: UDFObservableObject, RootViewModelable {
    
    private let i18NManager: I18NManager
    private let languageRepository: LanguageLocalizationRepository
    

    // Public state interface
    @Published var state: State = .init(
        splashRO: .init(displayTitleText: ""),
        isLoading: true
    )
    
    
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
    
    
    init(i18NManager: I18NManager, languageRepository: LanguageLocalizationRepository) {
        self.i18NManager = i18NManager
        self.languageRepository = languageRepository
        
        let languageType = i18NManager.getLanguageType()
        let initialSplashRO = createSplashRO(languageType: languageType)
        
        let initialState: State = .init(
            splashRO: initialSplashRO,
            isLoading: true
        )
        self.state = initialState
        
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
        var splashRO: SplashRO
        var isLoading: Bool
    }
}


// MARK: Splash
private extension RootViewModel {
    
    func createSplashRO(languageType: LanguageType) -> SplashRO {
        let titleTextKey = "LaunchScreen_title"
        let titleText = languageRepository.getString(key: titleTextKey, lanCode: languageType.lanCode)
        return .init(displayTitleText: titleText)
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
