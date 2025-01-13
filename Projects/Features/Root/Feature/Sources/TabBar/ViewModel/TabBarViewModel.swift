//
//  TabBarViewModel.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

import SwiftUI
import Combine

import BaseFeature



class TabBarViewModel: UDFObservableObject, TabBarViewModelable {
    
    // State
    @Published var state: State
    
    var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = .init()
    
    
    // Router
    @Published private var _router: WeakTabBarRouting = .init(nil)
    var router: TabBarRouting? {
        get { _router.value }
        set { _router = WeakTabBarRouting(newValue) }
    }
    
    
    init() {
        
        // Initial state
        self.state = .init(
            tabItem: [
                .allMarketTicker : .init(
                    titleText: "24hTicker",
                    systemIconName: "24.square"
                ),
                .setting : .init(
                    titleText: "Setting",
                    systemIconName: "gear"
                ),
            ]
        )
        
        createStateStream()
    }
}

extension TabBarViewModel {
    
    struct State {
        var tabItem: [TabBarPage: TabItem]
    }
    
    enum Action {
        
        // 로컬라이제이션 관련 액션
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
