//
//  TabBarBuilder.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

import SwiftUI

import AllMarketTickerFeature
import BaseFeature

class TabBarBuilder {
    
    func build() -> TabBarRouter {
        
        let viewModel: TabBarViewModel = .init()
        let view = TabBarView(viewModel: viewModel)
        let allMarketTickerBuilder = AllMarketTickerBuilder()
        let router = TabBarRouter(
            allMarketTickerBuilder: allMarketTickerBuilder,
            view: view,
            viewModel: viewModel
        )
        
        return router
    }
}
