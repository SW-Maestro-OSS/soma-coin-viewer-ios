//
//  TabBarViewModel.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

import SwiftUI
import Combine

import BaseFeatureInterface

class TabBarViewModel: UDFObservableObject {
    
    @Published var state: State
    
    var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = .init()
    
    init() {
        
        // Initial state
        self.state = .init(
            presentingPages: TabBarPage.orderedPages,
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
    
    func binding(page: TabBarPage) -> Binding<TabItem> {
        
        Binding { self.state.tabItem[page]! }
        set: { _ in }
    }
}

extension TabBarViewModel {
    
    struct State {
        var presentingPages: [TabBarPage]
        var tabItem: [TabBarPage: TabItem]
    }
    
    enum Action {
        
        // 로컬라이제이션 관련 액션
    }
}
