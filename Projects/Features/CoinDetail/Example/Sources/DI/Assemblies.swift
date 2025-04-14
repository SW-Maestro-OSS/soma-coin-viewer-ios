//
//  Assemblies.swift
//  CoinDetailModule
//
//  Created by choijunios on 11/1/24.
//

import Foundation

import DomainInterface
import Domain
import DataSource
import Repository
import WebSocketManagementHelper
import AlertShooter

import Swinject

public class Assemblies: Assembly {
    
    public func assemble(container: Swinject.Container) {
        
        // MARK: Service
        container.register(WebSocketService.self) { _ in
            BinanceWebSocketService()
        }
        .inObjectScope(.container)
        
        // MARK: Shared
        container.register(AlertShooter.self) { _ in
            DefaultAlertShooter()
        }
        .inObjectScope(.container)
        container.register(WebSocketManagementHelper.self) { resolver in
            DefaultWebSocketManagementHelper(
                webSocketService: resolver.resolve(WebSocketService.self)!,
                alertShooter: resolver.resolve(AlertShooter.self)!
            )
        }
        .inObjectScope(.container)
        
        // MARK: Repository
        container.register(OrderbookRepository.self) { _ in
            BinanceOrderbookRepository()
        }
        
        // MARK: UseCase
        container.register(CoinDetailPageUseCase.self) { _ in
            DefaultCoinDetailPageUseCase()
        }
    }
}
