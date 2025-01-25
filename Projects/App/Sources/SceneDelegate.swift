//
//  SceneDelegate.swift
//  CoinViewer
//
//  Created by choijunios on 1/25/25.
//

import UIKit

import WebSocketManagementHelper
import CoreUtil

class SceneDelegate: NSObject, UISceneDelegate {
    
    // Service locater
    @Injected private var webSocketManagementHelper: WebSocketManagementHelper
    
    
    // MARK: App life cycle management
    func sceneDidEnterBackground(_ scene: UIScene) {
        print(#function)
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print(#function)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print(#function)
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print(#function)
    }
}
