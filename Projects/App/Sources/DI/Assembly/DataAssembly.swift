//
//  DataAssembly.swift
//  CoinViewer
//
//  Created by choijunios on 9/26/24.
//

import Foundation

import Domain
import DomainInterface

import Repository
import DataSource

import I18N

import Swinject

public class DataAssembly: Assembly {
    
    public func assemble(container: Swinject.Container) {
        
        // MARK: Servcie
        container.register(UserConfigurationService.self) { _ in
            DefaultUserConfigurationService()
        }
        
        container.register(WebSocketService.self) { _ in
            BinanceWebSocketService()
        }
        .inObjectScope(.container)
        
        container.register(HTTPService.self) { _ in
            DefaultHTTPService()
        }
        .inObjectScope(.container)
        
        container.register(ExchangeRateService.self) { _ in
            DefaultExchangeRateService()
        }
        
        
        // MARK: Repository
        container.register(UserConfigurationRepository.self) { _ in
            DefaultUserConfigurationRepository()
        }
        .inObjectScope(.container)
        
        container.register(AllMarketTickersRepository.self) { _ in
            BinanceAllMarketTickersRepository()
        }
        
        container.register(ExchangeRateRepository.self) { _ in
            DefaultExchangeRateRepository()
        }
        
        container.register(OrderbookRepository.self) { _ in
            BinanceOrderbookRepository()
        }
        
        container.register(SingleMarketTickerRepository.self) { _ in
            BinanceSingleMarketTickerRepository()
        }
        
        container.register(TradeRepository.self) { _ in
            BinanceTradeRepository()
        }
    }
}
