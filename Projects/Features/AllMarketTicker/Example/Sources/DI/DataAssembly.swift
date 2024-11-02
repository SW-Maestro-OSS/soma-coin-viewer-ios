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
            DefaultWebSocketService()
        }
        .inObjectScope(.container)
        
        
        // MARK: Repository
        container.register(WebSocketConfiguable.self) { _ in
            WebSocketConfiguration()
        }
        .inObjectScope(.container)
        
        container.register((any AllMarketTickerRepository).self) { _ in
            DefaultAllMarketTickerRepository()
        }
    }
}

public class WebSocketConfiguration: WebSocketConfiguable {
    
    public let baseURL: String = "wss://stream.binance.com:443/ws"
    
    public let streamName: [WebSocketStream : String] = [
        .allMarketTickers : "!ticker@arr"
    ]
}
