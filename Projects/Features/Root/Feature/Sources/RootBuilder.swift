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
    // Dependency
    @Injected private var rootPageUseCase: RootPageUseCase
    @Injected private var alertShooter: AlertShooter
    @Injected private var i18NManager: I18NManager

    public init() { }
    
    public func build() -> RootRoutable {
        let viewModel = RootViewModel(
            useCase: rootPageUseCase,
            alertShooter: alertShooter,
            i18NManager: i18NManager
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
