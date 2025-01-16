//
//  Assemblies.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

import RootFeatureTesting

import BaseFeature
import WebSocketManagementHelper

import Swinject

class Assemblies: Assembly {
    
    func assemble(container: Container) {
        
        container.register(WebSocketManagementHelper.self) { _ in
            StubWebSocketHelper()
        }
    }
}

