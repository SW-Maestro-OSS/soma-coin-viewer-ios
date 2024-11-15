//
//  Router.swift
//  BaseFeatureInterface
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI

public class Router: ObservableObject  {
    
    @Published public var path: NavigationPath = .init()
    
    public init() { }
    
    public func present<Destination: Hashable>(destination: Destination) {
        
        path.append(destination)
    }
    
    public func pop() {
        
        path.removeLast()
    }
}
