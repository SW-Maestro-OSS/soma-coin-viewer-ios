//
//  TabBarBuilder.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

import SwiftUI

import BaseFeature

class TabBarCoordinator {
    
    func build() -> TabBarRouter {
        
        let viewModel: TabBarViewModel = .init()
        let view = TabBarView(viewModel: viewModel)
        let router = TabBarRouter(view: view, viewModel: viewModel)
        
        return router
    }
}
