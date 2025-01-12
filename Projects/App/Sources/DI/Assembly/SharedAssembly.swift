//
//  SharedAssembly.swift
//  CoinViewer
//
//  Created by choijunios on 12/4/24.
//

import WebSocketManagementHelper
import WebSocketManagementHelperInterface
import I18NInterface

import Swinject
import I18N

public class SharedAssembly: Assembly {
    
    public func assemble(container: Swinject.Container) {
        
        // MARK: WebSocketManagementHelper
        container.register(WebSocketManagementHelper.self) { _ in
            
            DefaultWebSocketManagementHelper()
        }
        .inObjectScope(.container)
        
        //MARK: I18NManager
        container.register(I18NManager.self) { _ in
            DefaultI18NManager()
        }
        .inObjectScope(.container)
    }
}
