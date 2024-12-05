
import UIKit

import WebSocketManagementHelperInterface
import CoreUtil

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        // #1. 의존성 주입
        dependencyInjection()
        
        // #2. 웹소켓 연결
        let webSocketHelper = DependencyInjector.shared.resolve(WebSocketManagementHelper.self)
        webSocketHelper.requestConnection(connectionType: .freshStart)
        
        // #3. 앱 런칭 후 2초동안 스플래쉬화면을 유지
        sleep(2)
        
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
