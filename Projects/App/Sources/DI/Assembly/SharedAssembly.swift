//
//  SharedAssembly.swift
//  CoinViewer
//
//  Created by choijunios on 12/4/24.
//

import WebSocketManagementHelper
import WebSocketManagementHelperInterface

import Swinject

public class SharedAssembly: Assembly {
    
    public func assemble(container: Swinject.Container) {
        
        // MARK: WebSocketManagementHelper
        container.register(WebSocketManagementHelper.self) { _ in
            
            DefaultWebSocketManagementHelper()
        }
        .inObjectScope(.container)
    }
}
