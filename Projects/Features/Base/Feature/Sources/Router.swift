//
//  Router.swift
//  BaseFeatureInterface
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI

public protocol Routable: AnyObject {
    
    associatedtype ViewModel
}

open class Router<ViewModel>: Routable {
    
    public let view: AnyView
    public let viewModel: ViewModel
    
    public private(set) var children: [any Routable] = []
    
    public init(view: AnyView, viewModel: ViewModel) {
        
        self.view = view
        self.viewModel = viewModel
    }
    
    public func attach(_ router: any Routable) {
        children.append(router)
    }
    
    public func dettach(_ router: any Routable) {
        
        let childIndex = children.firstIndex(where: { $0 === router })
        
        if let childIndex {
            children.remove(at: childIndex)
        }
    }
}
