//
//  RootBuilder.swift
//  RootModule
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI
import Combine

import DomainInterface

import BaseFeature

import I18N
import WebSocketManagementHelper
import AlertShooter
import CoreUtil

public final class RootBuilder {
    public init() { }
    
    public func build() -> RootRoutable {
        let viewModel = RootViewModel(
            useCase: DependencyInjector.shared.resolve(),
            alertShooter: DependencyInjector.shared.resolve(),
            i18NManager: DependencyInjector.shared.resolve()
        )
        let view = RootView(viewModel: viewModel)
        let tabBarBuilder = TabBarBuilder()
        let router = RootRouter(
            view: view,
            viewModel: viewModel,
            tabBarBuilder: tabBarBuilder
        )
        return router
    }
}
