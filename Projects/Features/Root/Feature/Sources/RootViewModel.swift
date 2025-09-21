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

enum RootPageAction {
    // Events
    case onAppear
    case appIsLoaded
    
    // Internal envent
    case updateDestination(RootDestination)
}

@MainActor
final class RootViewModel: UDFObservableObject, RootViewModelable {
    // Dependency
    private let useCase: RootPageUseCase
    private let alertShooter: AlertShooter
    private let i18NManager: I18NManager
    private let localizedStrProvider: LocalizedStrProvider
    

    // Router
    weak var router: RootRouting!
    
    
    // State
    @Published var state: State = .init()
    private var isFirstAppear: Bool = true
    
    
    // Publishers
    let action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = .init()
    
    typealias Action = RootPageAction
    
    init(useCase: RootPageUseCase, alertShooter: AlertShooter, i18NManager: I18NManager, localizedStrProvider: LocalizedStrProvider) {
        self.useCase = useCase
        self.alertShooter = alertShooter
        self.i18NManager = i18NManager
        self.localizedStrProvider = localizedStrProvider
        
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
                
                // 환율 정보 가져오기
                prepareExchangeRate()
            }
        case .appIsLoaded:
            return Just(action)
                .delay(for: 1, scheduler: DispatchQueue.main)
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
        case .updateDestination(let destination):
            newState.rootDestination = destination
        default:
            return state
        }
        
        return newState
    }
}


// MARK: Exchange rate
private extension RootViewModel {
    func prepareExchangeRate() {
        Task {
            do {
                try await useCase.prepareExchangeRate()
                action.send(.appIsLoaded)
            } catch {
                var alertModel = AlertModel(
                    titleKey: .alertKey(contents: .title(.exchangeRateError)),
                    messageKey: .alertKey(contents: .message(.failedToGetExchangerate))
                )
                alertModel.add(action: .init(
                    titleKey: .alertKey(contents: .actionTitle(.retry))
                ) {
                    Task { @MainActor [weak self] in
                        guard let self else { return }
                        prepareExchangeRate()
                    }
                })
                alertModel.add(action: .init(
                    titleKey: .alertKey(contents: .actionTitle(.ignore)),
                    role: .cancel
                ))
                alertShooter.shoot(alertModel)
            }
        }
    }
}


// MARK: Action & State
extension RootViewModel {
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
        .init(
            displayTitleText: localizedStrProvider.getString(
                key: .pageKey(page: .splash(contents: .title)),
                languageType: languageType
            )
        )
    }
}
