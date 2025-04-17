//
//  RootRouter.swift
//  RootModule
//
//  Created by choijunios on 1/13/25.
//

import SwiftUI

import BaseFeature

public protocol RootViewModelable {
    func updateDestination(destination: RootDestination)
}

public typealias RootRoutable = Router<RootViewModelable> & RootRouting

class RootRouter: RootRoutable {
    // Navigation
    private var destination: RootDestination?
    
    // Builder
    private let tabBarBuilder: TabBarBuilder
    
    // Router
    private var tabBarRouter: TabBarRouter?
    
    init(view: RootView, viewModel: RootViewModel, tabBarBuilder: TabBarBuilder) {
        self.tabBarBuilder = tabBarBuilder
        super.init(view: AnyView(view), viewModel: viewModel)
        viewModel.router = self
    }
}


// MARK: RootRouting
extension RootRouter {
    func request(_ request: RootRoutingRequest) {
        switch request {
        case .presentTabBarPage:
            destination = .tabBarPage
            viewModel.updateDestination(destination: .tabBarPage)
        }
    }
    
    func view(destination: RootDestination) -> AnyView {
        switch destination {
        case .tabBarPage:
            let tabBarRouter = tabBarBuilder.build()
            self.tabBarRouter = tabBarRouter
            attach(tabBarRouter)
            return tabBarRouter.view
        }
    }
}
