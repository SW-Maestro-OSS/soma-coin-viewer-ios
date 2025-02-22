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

public enum RootDestination: Hashable {
    
    case mainTabBarPage
    case coinDetailPage
}

public final class RootBuilder {
    
    // Service locator
    @Injected private var i18NManager: I18NManager
    @Injected private var languageLocalizationRepository: LanguageLocalizationRepository
    @Injected private var alertShooter: AlertShooter

    public init() { }
    
    public func build() -> RootRouter {
        let viewModel = RootViewModel(
            i18NManager: i18NManager,
            languageRepository: languageLocalizationRepository,
            alertShooter: alertShooter
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
