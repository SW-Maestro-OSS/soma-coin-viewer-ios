//
//  Assemblies.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

import RootFeatureTesting

import BaseFeatureInterface
import WebSocketManagementHelperInterface
import BaseFeature

import Swinject

class Assemblies: Assembly {
    
    func assemble(container: Container) {
        
        container.register(Router.self) { _ in
            Router()
        }
        
        container.register(WebSocketManagementHelper.self) { _ in
            MockWebSocketHelper()
        }
    }
}

