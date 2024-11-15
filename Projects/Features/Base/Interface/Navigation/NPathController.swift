//
//  NPathController.swift
//  BaseFeatureInterface
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI

open class NPathController<Destination>: ObservableObject where Destination: Hashable {
    
    @Published public var path: NavigationPath = .init()
    
    public init() { }
    
    public func present(destination: Destination) { }
}
