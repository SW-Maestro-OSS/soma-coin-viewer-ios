//
//  TabBarRouter.swift
//  RootModule
//
//  Created by choijunios on 1/13/25.
//

import SwiftUI

import BaseFeature

protocol TabBarRouting: AnyObject {
    
    func destinationView(_ page: TabBarPage) -> any View
}

class TabBarRouter: Router<TabBarViewModelable>, TabBarRouting {
    
    init(view: TabBarView, viewModel: TabBarViewModel) {
        super.init(view: AnyView(view), viewModel: viewModel)
    }
}


// MARK: TabBarRouting
extension TabBarRouter {
    
    func destinationView(_ page: TabBarPage) -> any View {
        switch page {
        case .allMarketTicker:
            
            Text("allMarketTicker")
            
        case .setting:
            
            Text("setting")
        }
    }
}
