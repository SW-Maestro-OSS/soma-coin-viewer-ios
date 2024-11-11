//
//  DataAssembly.swift
//  AllMarketTickerFeatureExample
//
//  Created by choijunios on 11/1/24.
//

import Foundation

import DataSource
import Repository
import DomainInterface


import Swinject

public class DataAssembly: Assembly {
    
    public func assemble(container: Swinject.Container) {
        
        // MARK: DataSource
        container.register(WebSocketService.self) { _ in
            BinanceWebSocketService()
        }
        .inObjectScope(.container)
        
        
        // MARK: Repository

        container.register(AllMarketTickersRepository.self) { _ in
            BinanceAllMarketTickersRepository()
        }
    }
}
