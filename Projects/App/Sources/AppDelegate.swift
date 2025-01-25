
import UIKit

import RootFeature

import DomainInterface

import WebSocketManagementHelper
import CoreUtil

@MainActor
class AppDelegate: NSObject, UIApplicationDelegate {
    
    private(set) var rootRouter: RootRouter!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        // 의존성 주입
        dependencyInjection()
        
        // RootRouter참조
        self.rootRouter = RootBuilder().build()
        
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        let sceneConfig = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        
        // SceneDelegate클래스 지정
        sceneConfig.delegateClass = SceneDelegate.self
        
        return sceneConfig
    }
    
    private func dependencyInjection() {
        
        DependencyInjector.shared.assemble([
            DataAssembly(),
            SharedAssembly(),
            DomainAssembly()
        ])
    }
}
