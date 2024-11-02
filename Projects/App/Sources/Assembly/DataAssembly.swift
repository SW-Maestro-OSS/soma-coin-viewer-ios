//
//  DataAssembly.swift
//  CoinViewer
//
//  Created by choijunios on 9/26/24.
//

import Foundation

// Domain
import Domain
import DomainInterface

// Data
import Repository
import DataSource

// Utils


import Swinject

public class DataAssembly: Assembly {
    
    public func assemble(container: Swinject.Container) {
        
        // MARK: DataSource
        container.register(UserConfigurationService.self) { _ in
            DefaultUserConfigurationService()
        }
        
        container.register(WebSocketService.self) { _ in
            DefaultWebSocketService()
        }
        .inObjectScope(.container)
        
        
        // MARK: Repository
        container.register(WebSocketConfiguable.self) { _ in
            WebSocketConfiguration()
        }
        .inObjectScope(.container)
        
        container.register(UserConfigurationRepository.self) { _ in
            DefaultUserConfigurationRepository()
        }
        .inObjectScope(.container)
        
        container.register((any AllMarketTickerRepository).self) { _ in
            DefaultAllMarketTickerRepository()
        }
    }
}
