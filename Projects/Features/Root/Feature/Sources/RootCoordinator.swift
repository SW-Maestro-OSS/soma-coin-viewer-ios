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
    
    @Injected var nPathController: NPathController<RootDestination>
    
    public var present: ((OutsideDestination) -> ())? = nil
    public weak var delegate: CoordinatorFinishDelegate? = nil
    
    public func start() -> RootView {
    
        return RootView()
    }
}

extension RootCoordinator {
    public enum OutsideDestination { }
}
