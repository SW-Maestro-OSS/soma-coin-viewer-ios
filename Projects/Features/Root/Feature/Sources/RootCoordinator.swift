//
//  RootCoordinator.swift
//  RootModule
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI

import BaseFeatureInterface
import CoreUtil

enum RootDestination: Hashable {
    
    case mainTabBarPage
    case coinDetailPage
}

public class RootCoordinator: Coordinator {
    
    private let nPathController: NPathController<RootDestination> = .init()
    
    
    public init() { }
    
    
    public func start() -> RootView {
    
        defer {
            
            // Test
            DispatchQueue.main.asyncAfter(deadline: .now()+3) { [weak self] in
                
                self?.nPathController.present(destination: .mainTabBarPage)
            }
        }
        
        return RootView(
            nPathController: nPathController,
            destinationView: present
        )
    }
    
    
    public var present: ((OutsideDestination) -> ())? = nil
    public weak var delegate: CoordinatorFinishDelegate? = nil
}

extension RootCoordinator {
    
    @ViewBuilder
    func present(destination: RootDestination) -> any View {
        
        switch destination {
        case .mainTabBarPage:
            
            // start coordinator
            
            Text("mainTabBarPage")
        case .coinDetailPage:
            
            // start coordinator
            
            Text("coinDetailPage")
        }
    }
}

extension RootCoordinator {
    public enum OutsideDestination { }
}
