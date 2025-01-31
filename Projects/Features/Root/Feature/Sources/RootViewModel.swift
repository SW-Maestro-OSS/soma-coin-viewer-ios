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
import AlertShooter
import CoreUtil

final class RootViewModel: UDFObservableObject, RootViewModelable, AlertShooterListener {
    
    // Dependency
    private let i18NManager: I18NManager
    private let languageRepository: LanguageLocalizationRepository
    private let alertShooter: AlertShooter
    

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
    
    
    init(
        i18NManager: I18NManager,
        languageRepository: LanguageLocalizationRepository,
        alertShooter: AlertShooter
    ) {
        self.i18NManager = i18NManager
        self.languageRepository = languageRepository
        self.alertShooter = alertShooter
        
        // Listener
        alertShooter.request(listener: self)
        
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
        case .presentAlert, .alertIsDismissed:
            return Just(action)
                .delay(for: 0.35, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
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
        case .alertIsDismissed:
            if !state.alertQueue.isEmpty {
                let nextAlertRO = newState.alertQueue.removeFirst()
                newState.presentingAlertRO = nextAlertRO
                newState.isAlertPresenting = true
            } else {
                newState.isAlertPresenting = false
                newState.presentingAlertRO = nil
            }
        case .presentAlert(let alertRO):
            if state.isAlertPresenting {
                newState.alertQueue.append(alertRO)
            } else {
                newState.presentingAlertRO = alertRO
                newState.isAlertPresenting = true
            }
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
        case presentAlert(ro: AlertRO)
        
        case alertIsDismissed
    }
    
    struct State {
        var splashRO: SplashRO
        var isLoading: Bool
        
        fileprivate var alertQueue: [AlertRO] = []
        var presentingAlertRO: AlertRO? = nil
        var isAlertPresenting: Bool = false
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


// MARK: AlertShooterListener
extension RootViewModel {
    func alert(model: AlertModel) {
        let currentLan = i18NManager.getLanguageType()
        
        // AlertAction ROs
        let actionROs = model.actions.map { actionModel in
            let titleText = languageRepository.getString(
                key: actionModel.titleKey,
                lanCode: currentLan.lanCode
            )
            return AlertActionRO(
                titleText: titleText,
                titleTextColor: actionModel.config.textColor,
                action: actionModel.action
            )
        }
        
        // Alert RO
        var messageText: String = ""
        if let messageKey = model.messageKey {
            messageText = languageRepository.getString(
                key: messageKey,
                lanCode: currentLan.lanCode
            )
        }
        let renderObject = AlertRO(
            titleText: languageRepository.getString(
                key: model.titleKey,
                lanCode: currentLan.lanCode
            ),
            messageText: messageText,
            actions: actionROs
        )
        self.action.send(.presentAlert(ro: renderObject))
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
