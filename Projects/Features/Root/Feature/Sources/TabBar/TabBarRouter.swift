//
//  TabBarRouter.swift
//  RootModule
//
//  Created by choijunios on 1/13/25.
//

import SwiftUI

import SettingFeature
import AllMarketTickerFeature
import BaseFeature

protocol TabBarRouting: AnyObject {
    
    func destinationView(_ page: TabBarPage) -> any View
}

class TabBarRouter: Router<TabBarViewModelable>, TabBarRouting {
    
    // Builder
    private let allMarketTickerBuilder: AllMarketTickerBuilder
    private let settingBuilder: SettingBuilder
    
    init(
        settingBuilder: SettingBuilder,
        allMarketTickerBuilder: AllMarketTickerBuilder,
        view: TabBarView,
        viewModel: TabBarViewModel) {
        
        self.settingBuilder = settingBuilder
        self.allMarketTickerBuilder = allMarketTickerBuilder
        
        super.init(view: AnyView(view), viewModel: viewModel)
        
        viewModel.router = self
    }
}


// MARK: TabBarRouting
extension TabBarRouter {
    
    func destinationView(_ page: TabBarPage) -> any View {
        switch page {
        case .allMarketTicker:
            
            let router = allMarketTickerBuilder.build()
            attach(router)
            return router.view
            
        case .setting:
            
            let router = settingBuilder.build(listener: viewModel)
            attach(router)
            return router.view
        }
    }
}
