//
//  SceneDelegate.swift
//
//
//

import UIKit

import AllMarketTickerFeature
import CoreUtil

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        DependencyInjector.shared.assemble([
            DataAssembly()
        ])
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = SampleViewController()
        window?.makeKeyAndVisible()
    }
}
