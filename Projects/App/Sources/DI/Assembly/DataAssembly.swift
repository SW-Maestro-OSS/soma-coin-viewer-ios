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
        container.register(KeyValueStoreService.self) { _ in
            DefaultKeyValueStoreService()
        }
        .inObjectScope(.container)
        
        container.register(WebSocketService.self) { _ in
            BinanceWebSocketService()
        }
        .inObjectScope(.container)
        
        container.register(HTTPService.self) { _ in
            DefaultHTTPService()
        }
        .inObjectScope(.container)
        
        
        // MARK: DataSource
        container.register(UserConfigurationDataSource.self) { resolver in
            DefaultUserConfigurationDataSource(
                service: resolver.resolve(KeyValueStoreService.self)!
            )
        }
        .inObjectScope(.container)
        container.register(CoinTradeDataSource.self) { _ in
            BinanceCoinTradeDataSource()
        }
        container.register(AllMarketTickersDataSource.self) { _ in
            BinanceAllMarketTickersDataSource()
        }
        container.register(ExchangeRateDataSource.self) { _ in
            OpenXExchangeRateDataSource()
        }
        .inObjectScope(.container)
        
        
        // MARK: Repository
        container.register(UserConfigurationRepository.self) { _ in
            DefaultUserConfigurationRepository()
        }
        
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
        
        container.register(CoinTradeRepository.self) { _ in
            BinanceCoinTradeRepository()
        }
    }
}
