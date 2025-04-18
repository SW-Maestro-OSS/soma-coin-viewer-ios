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

public enum RootRoutingRequest {
    case presentTabBarPage
}

public protocol RootRouting: AnyObject {
    func request(_ request: RootRoutingRequest)
    func view(destination: RootDestination) -> AnyView
}

final class RootViewModel: UDFObservableObject, RootViewModelable {
    
    // Dependency
    private let i18NManager: I18NManager
    private let languageRepository: LanguageLocalizationRepository
    

    // Router
    weak var router: RootRouting!
    
    
    // State
    @Published var state: State = .init()
    private var alertQueue: [AlertRO] = []
    private var isFirstAppear: Bool = true
    
    
    // Publishers
    let action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = .init()
    
    
    init(
        i18NManager: I18NManager,
        languageRepository: LanguageLocalizationRepository
    ) {
        self.i18NManager = i18NManager
        self.languageRepository = languageRepository
        
        // Splash
        let languageType = i18NManager.getLanguageType()
        let splashRO = createSplashRO(languageType: languageType)
        self.state = .init(splashRO: splashRO)
        
        // Create state stream
        createStateStream()
    }
    
    func action(_ action: Action) { self.action.send(action) }
    
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
            router?.request(.presentTabBarPage)
        case .alertIsDismissed:
            if !alertQueue.isEmpty {
                let nextAlertRO = alertQueue.removeFirst()
                newState.presentingAlertRO = nextAlertRO
                newState.isAlertPresenting = true
            } else {
                newState.isAlertPresenting = false
                newState.presentingAlertRO = nil
            }
        case .presentAlert(let alertRO):
            if state.isAlertPresenting {
                alertQueue.append(alertRO)
            } else {
                newState.presentingAlertRO = alertRO
                newState.isAlertPresenting = true
            }
        case .updateDestination(let destination):
            newState.rootDestination = destination
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
        case updateDestination(RootDestination)
    }
    
    struct State {
        var splashRO: SplashRO?
        var rootDestination: RootDestination?
        var presentingAlertRO: AlertRO? = nil
        var isAlertPresenting: Bool = false
    }
}


// MARK: Navigation state
extension RootViewModel {
    func updateDestination(destination: RootDestination) {
        action.send(.updateDestination(destination))
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
