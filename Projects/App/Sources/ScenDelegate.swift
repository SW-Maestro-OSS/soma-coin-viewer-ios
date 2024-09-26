import UIKit
import SwiftUI
import PresentationUtil

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            // MARK: 의존성 주입
            setDependencyInjection()
            
            // SwiftUI View를 Scene에 연결
            let contentView = ContentView()
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // 앱이 백그라운드로 들어갈 때 호출되는 함수
        print("Scene did enter background")
    }
    
    
    /// 의존성 주입을 진행합니다.
    func setDependencyInjection() {
        DependencyInjector.shared.assemble([
            
            DataAssembly()
        ])
    }
}

