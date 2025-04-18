//
//  App.swift
//  CoinViewer
//
//  Created by choijunios on 12/4/24.
//

import SwiftUI

import RootFeature
import CoreUtil
import AlertShooter

@main
struct CoinViewerApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        
        WindowGroup {
            appDelegate.rootRouter.view
                .environmentObject(DependencyInjector.shared.resolve(AlertShooter.self))
        }
    }
}
