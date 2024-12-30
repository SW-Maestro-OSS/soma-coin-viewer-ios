//
//  Assemblies.swift
//  AllMarketTickerFeatureExample
//
//  Created by choijunios on 11/1/24.
//

import Foundation

import DataSource
import Repository

import DomainInterface
import Domain

import WebSocketManagementHelper
import WebSocketManagementHelperInterface


import Swinject

public class Assemblies: Assembly {
    
    public func assemble(container: Swinject.Container) {
        
        // MARK: DataSource
        container.register(UserConfigurationService.self) { _ in
            DefaultUserConfigurationService()
        }
        
        container.register(WebSocketService.self) { _ in
            BinanceWebSocketService()
        }
        .inObjectScope(.container)
        
        
        // MARK: Shared
        container.register(WebSocketManagementHelper.self) { _ in
            
            DefaultWebSocketManagementHelper()
        }
        .inObjectScope(.container)
        
        
        // MARK: Repository
        container.register(UserConfigurationRepository.self) { _ in
            DefaultUserConfigurationRepository()
        }
        .inObjectScope(.container)
        
        container.register(AllMarketTickersRepository.self) { _ in
            BinanceAllMarketTickersRepository()
        }
        
        
        // MARK: UseCase
        container.register(AllMarketTickersUseCase.self) { _ in
            DefaultAllMarketTickersUseCase()
        }
    }
}
