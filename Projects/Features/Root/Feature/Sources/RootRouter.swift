//
//  RootRouter.swift
//  RootModule
//
//  Created by choijunios on 1/13/25.
//

import SwiftUI

import BaseFeature

protocol RootRouting: AnyObject {
    
    func presentMainTabBar()
    
    func getPath() -> Binding<NavigationPath>
    
    func destinationView(destination: RootDestination) -> any View
}

public class RootRouter: Router<RootViewModelable>, RootRouting {
    
    @Published private var path: NavigationPath = .init()
    
    
    // Builder
    private let tabBarBuilder: TabBarBuilder
    
    
    init(tabBarBuilder: TabBarBuilder, view: RootView, viewModel: RootViewModel) {
        
        self.tabBarBuilder = tabBarBuilder
        
        super.init(view: AnyView(view), viewModel: viewModel)
        
        viewModel.router = self
    }
    
    private func present(_ destination: RootDestination) {
        path.append(destination)
    }
    
    private func pop() {
        path.removeLast()
    }
}


// MARK: RootRouting
extension RootRouter {
    
    func presentMainTabBar() {
        
        present(.mainTabBarPage)
    }
    
    func getPath() -> Binding<NavigationPath> {
        Binding(get: { [weak self] in
            self?.path ?? .init()
        }, set: { [weak self] newPath in
            self?.path = newPath
        })
    }
    
    func destinationView(destination: RootDestination) -> any View {
        
        switch destination {
        case .mainTabBarPage:
            
            let tabBarRouter = tabBarBuilder.build()
            attach(tabBarRouter)
            
            return tabBarRouter.view
            
        case .coinDetailPage:
            
            return Text("coinDetailPage")
        }
    }
}
