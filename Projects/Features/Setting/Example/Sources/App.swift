//
//  SceneDelegate.swift
//
//
//

import SwiftUI

@testable import SettingFeature

import DomainInterface
import CoreUtil

@main
struct CoinViewerApp : App {
    
    @UIApplicationDelegateAdaptor var AppDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            SettingView(viewModel: .init(
                i18NManager: DependencyInjector.shared.resolve(),
                userConfigurationRepository: DependencyInjector.shared.resolve()
            ))
        }
    }
}
