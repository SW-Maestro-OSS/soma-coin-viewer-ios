//
//  App.swift
//  RootModule
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI

import RootFeature
import BaseFeatureInterface
import CoreUtil

@main
struct RootModuleApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        
        WindowGroup {
            appDelegate.rootCoordinator.start()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var rootCoordinator: RootCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DependencyInjector.shared.register(Router.self, Router())
        
        self.rootCoordinator = .init()
        
        return true
    }
}
