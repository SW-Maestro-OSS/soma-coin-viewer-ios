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
    
    // Dependency inject
    @Injected private var webSocketHelper: WebSocketManagementHelper
    @Injected private var i18NManager: I18NManager
    @Injected private var exchangeRateUseCase: ExchangeRateUseCase

    public init() { }
    
    public func build() -> RootRouter {
        
        let viewModel = RootViewModel(
            i18NManager: i18NManager,
            webSocketHelper: webSocketHelper,
            exchangeRateUseCase: exchangeRateUseCase
        )
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
