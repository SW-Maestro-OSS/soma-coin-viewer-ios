//
//  App.swift
//  RootModule
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI

import RootFeature
import BaseFeature
import CoreUtil

@main
struct RootModuleApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        
        WindowGroup {
            appDelegate.rootRouter.view
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var rootRouter: RootRouter!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DependencyInjector.shared.assemble([
            Assemblies()
        ])
        
        self.rootRouter = RootBuilder().build()
        
        return true
    }
}
