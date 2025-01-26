//
//  RootBuilder.swift
//  RootModule
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI
import Combine

import DomainInterface

import I18N
import WebSocketManagementHelper
import BaseFeature
import CoreUtil

public enum RootDestination: Hashable {
    
    case mainTabBarPage
    case coinDetailPage
}

public final class RootBuilder {

    public init() { }
    
    public func build() -> RootRouter {
        
        let viewModel = RootViewModel()
        let view = RootView(viewModel: viewModel)
        let tabBarBuilder = TabBarBuilder()
        let router = RootRouter(
            tabBarBuilder: tabBarBuilder,
            view: view,
            viewModel: viewModel
        )
        
        return router
    }
}
