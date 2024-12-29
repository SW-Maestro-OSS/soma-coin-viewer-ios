//
//  Coordinator.swift
//  BaseFeatureInterface
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI

public protocol Coordinator: AnyObject {
    
    associatedtype OutsideDestination
    associatedtype Content: View
    
    var present: ((OutsideDestination) -> ())? { get set }
    var children: [any Coordinator] { get set }
    
    var delegate: CoordinatorFinishDelegate? { get set }
    
    func start() -> Content
}

public protocol CoordinatorFinishDelegate: AnyObject {
    
    func coordinator(finished coordinator: any Coordinator)
}
