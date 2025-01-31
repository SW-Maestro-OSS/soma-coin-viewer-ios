//
//  SharedAssembly.swift
//  CoinViewer
//
//  Created by choijunios on 12/4/24.
//

import DataSource

import WebSocketManagementHelper
import I18N

import Swinject
import I18N

public class SharedAssembly: Assembly {
    
    public func assemble(container: Swinject.Container) {
        
        // MARK: WebSocketManagementHelper
        container.register(WebSocketManagementHelper.self) { resolver in
            DefaultWebSocketManagementHelper(
                webSocketService: resolver.resolve(WebSocketService.self)!
            )
        }
        .inObjectScope(.container)
        
        //MARK: I18NManager
        container.register(I18NManager.self) { _ in
            DefaultI18NManager()
        }
        .inObjectScope(.container)
    }
}
