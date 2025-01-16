
import UIKit

import RootFeature

import DomainInterface

import WebSocketManagementHelper
import CoreUtil

class AppDelegate: NSObject, UIApplicationDelegate {
    
    private(set) var rootRouter: RootRouter!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        // 의존성 주입
        dependencyInjection()
        
        // RootCoordinator할당
        self.rootRouter = RootBuilder().build()
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    private func dependencyInjection() {
        
        DependencyInjector.shared.assemble([
            DataAssembly(),
            SharedAssembly(),
            DomainAssembly()
        ])
    }
}
