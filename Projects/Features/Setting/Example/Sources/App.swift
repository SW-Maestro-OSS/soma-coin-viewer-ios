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
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            appDelegate.router?.view
        }
    }
}
