//
//  RootCoordinator.swift
//  RootModule
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI

import WebSocketManagementHelper
import BaseFeature
import CoreUtil

enum RootDestination: Hashable {
    
    case mainTabBarPage
    case coinDetailPage
}

public class RootCoordinator: Coordinator, CoordinatorFinishDelegate {
    
    // Dependency inject
    @Injected private var webSocketHelper: WebSocketManagementHelper
    @Injected private var router: Router
    
    public var children: [any Coordinator] = []
    
    public init() { }
    
    public func start() -> RootView {
        
        let viewModel: RootViewModel = .init(
            webSocketHelper: webSocketHelper
        )
        
        router.present(destination: RootDestination.mainTabBarPage)
        
        return RootView(
            viewModel: viewModel,
            router: router,
            destinationView: views
        )
    }
    
    
    public var present: ((OutsideDestination) -> ())? = nil
    public weak var delegate: CoordinatorFinishDelegate? = nil
}

extension RootCoordinator {
    
    
    func views(destination: RootDestination) -> any View {
        
        switch destination {
        case .mainTabBarPage:
            
            // start coordinator
            let tabBarCoordinator = TabBarCoordinator()
            tabBarCoordinator.delegate = self
            children.append(tabBarCoordinator)
            
            return tabBarCoordinator.start()
            
        case .coinDetailPage:
            
            // start coordinator
            
            return Text("coinDetailPage")
        }
    }
}


// MARK: Coordinator
extension RootCoordinator {
    public enum OutsideDestination { }
}


// MARK: CoordinatorFinishDelegate
extension RootCoordinator {
    
    public func coordinator(finished coordinator: any Coordinator) {
        
        // Remove from children arr
        if let index = children.firstIndex(where: { $0 === coordinator }) {
            
            self.children.remove(at: index)
        }
        
    }
}
