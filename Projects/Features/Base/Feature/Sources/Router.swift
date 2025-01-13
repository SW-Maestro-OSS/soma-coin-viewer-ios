//
//  Router.swift
//  BaseFeatureInterface
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI

open class Router<ViewModel> {
    
    public let view: AnyView
    public let viewModel: ViewModel
    
    public private(set) var children: [Router] = []
    
    public init(view: AnyView, viewModel: ViewModel) {
        
        self.view = view
        self.viewModel = viewModel
    }
    
    public func attach(_ router: Router) {
        children.append(router)
    }
    
    public func dettach(_ router: Router) {
        
        let childIndex = children.firstIndex(where: { $0 === router })
        
        if let childIndex {
            children.remove(at: childIndex)
        }
    }
}
