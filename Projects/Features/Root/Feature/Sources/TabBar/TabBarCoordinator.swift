//
//  TabBarCoordinator.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

import SwiftUI

import BaseFeatureInterface

class TabBarCoordinator: Coordinator {
    
    var present: ((OutsideDestination) -> ())?
    typealias Content = TabBarView
    
    weak var delegate: CoordinatorFinishDelegate?
    
    func start() -> TabBarView {
        
        let viewModel: TabBarViewModel = .init()
        
        return TabBarView(
            viewModel: viewModel,
            destinationView: tabViews(page:)
        )
    }
}


// MARK: TabViews
extension TabBarCoordinator {
    
    func tabViews(page: TabBarPage) -> any View {
        
        switch page {
        case .allMarketTicker:
            Text("allMarketTicker")
        case .setting:
            Text("setting")
        }
    }
}


// MARK: External navigaiton
extension TabBarCoordinator {
    
    enum OutsideDestination {
        
    }
}
