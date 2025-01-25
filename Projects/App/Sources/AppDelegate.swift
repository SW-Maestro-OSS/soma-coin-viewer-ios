
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
        
        // 최초 작업 실행
        executeInitialTask()
        
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


// MARK: Initial tasks
extension AppDelegate {
    
    func executeInitialTask() {
        
        // Service locator
        let webSocketManagementHelper: WebSocketManagementHelper = DependencyInjector.shared.resolve()
        let exchangeRateUseCase: ExchangeRateUseCase = DependencyInjector.shared.resolve()
        
        // 웹소켓 최초연결 시도
        webSocketManagementHelper.requestConnection(connectionType: .freshStart)
        
        // 환율정보 Fetch 시도
        exchangeRateUseCase.prepare()
    }
}
