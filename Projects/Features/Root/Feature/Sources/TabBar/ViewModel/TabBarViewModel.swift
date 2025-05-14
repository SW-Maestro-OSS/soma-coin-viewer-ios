//
//  TabBarViewModel.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

import SwiftUI
import Combine

import BaseFeature
import AllMarketTickerFeature
import CoinDetailFeature
import DomainInterface
import I18N
import CoreUtil

enum TabBarRoutingRequest {
    case presentCoinDetailPage(listener: CoinDetailPageListener, symbolInfo: CoinSymbolInfo)
    case dismissCoinDetailPage
}

protocol TabBarRouting: AnyObject {
    func request(_ request: TabBarRoutingRequest)
    func view(_ destination: TabBarPageDestination) -> AnyView
    func tabBarPage(_ page: TabBarPage) -> AnyView
}

enum TabBarViewAction {
    case onAppear
    case languageTypeUpdated(LanguageType)
    case upateDestination(NavigationPath)
    case popDestination
}

class TabBarViewModel: UDFObservableObject, TabBarViewModelable {
    // Dependency
    private let i18NManager: I18NManager
    private let localizedStrProvider: LocalizedStrProvider
    
    
    // State
    @Published var state: State = .init(tabItemROs: [], languageType: .english)
    private var isFirstAppear: Bool = true
    
    
    // Action
    typealias Action = TabBarViewAction
    var action: PassthroughSubject<Action, Never> = .init()
    
    
    // Stream
    var store: Set<AnyCancellable> = .init()
    
    
    // Router
    weak var router: TabBarRouting?
    
    init(i18NManager: I18NManager, localizedStrProvider: LocalizedStrProvider) {
        self.i18NManager = i18NManager
        self.localizedStrProvider = localizedStrProvider
        
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
        case .upateDestination(let newPath):
            newState.destinationPath = newPath
        default:
            return state
        }
        return newState
    }
}


// MARK: Navigation state
extension TabBarViewModel {
    func updateDestinationPath(path: NavigationPath) {
        action.send(.upateDestination(path))
    }
}


// MARK: Tab bar item creation & modification
private extension TabBarViewModel {
    func createTabBarItemROs(languageType: LanguageType) -> [TabBarItemRO] {
        let orderedPage: [TabBarPage] = [.market, .setting]
        return orderedPage.map { page in
            let displayText = localizedStrProvider.getString(
                key: getLocalizedKey(page: page),
                languageType: languageType
            )
            return TabBarItemRO(
                page: page,
                displayText: displayText,
                displayIconName: page.systemIconName
            )
        }
    }
    
    func getLocalizedKey(page: TabBarPage) -> I18N.LocalizedStrKey {
        switch page {
        case .market:
            .pageKey(page: .tabBar(contents: .tabIconMarketTitle))
        case .setting:
            .pageKey(page: .tabBar(contents: .tabIconSettingTitle))
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
        var destinationPath: NavigationPath = .init()
    }
}


// MARK: AllMarketTickerListener
extension TabBarViewModel {
    func request(_ request: AllMarketTickerPageListenerRequest) {
        switch request {
        case .presentCoinDetailPage(let listener, let symbolInfo):
            router?.request(.presentCoinDetailPage(listener: listener, symbolInfo: symbolInfo))
        case .dismissCoinDetailPage:
            router?.request(.dismissCoinDetailPage)
        }
    }
}
