//
//  Assemblies.swift
//  CoinDetailModule
//
//  Created by choijunios on 11/1/24.
//

import Foundation

import CoinDetailFeatureTesting
import DomainInterface
import Domain
import DataSource
import Repository
import WebSocketManagementHelper
import AlertShooter
import I18N

import Swinject

public class Assemblies: Assembly {
    
    public func assemble(container: Swinject.Container) {
        
        // MARK: Service
        container.register(WebSocketService.self) { _ in
            BinanceWebSocketService()
        }
        .inObjectScope(.container)
        container.register(HTTPService.self) { _ in
            DefaultHTTPService()
        }
        .inObjectScope(.container)
        
        // MARK: DataSource
        container.register(CoinTradeDataSource.self) { _ in
            BinanceCoinTradeDataSource()
        }
        
        // MARK: Shared
        container.register(AlertShooter.self) { _ in AlertShooter() }
        .inObjectScope(.container)
        container.register(WebSocketManagementHelper.self) { resolver in
            DefaultWebSocketManagementHelper(
                webSocketService: resolver.resolve(WebSocketService.self)!,
                streamDecoder: BinanceStreamDecoder(),
                alertShootable: resolver.resolve(AlertShooter.self)!
            )
        }
        .inObjectScope(.container)
        container.register(I18NManager.self) { _ in
            DefaultI18NManager(repository: DefaultUserConfigurationRepository())
        }
        
        // MARK: Repository
        container.register(OrderbookRepository.self) { _ in
            BinanceOrderbookRepository()
        }
        container.register(SingleMarketTickerRepository.self) { _ in
            BinanceSingleMarketTickerRepository()
        }
        container.register(CoinTradeRepository.self) { _ in
            BinanceCoinTradeRepository()
        }
        container.register(ExchangeRateRepository.self) { _ in
            FakeExchangeRateRepository()
        }
        
        // MARK: UseCase
        container.register(CoinDetailPageUseCase.self) { resolver in
            DefaultCoinDetailPageUseCase(
                orderbookRepository: resolver.resolve(OrderbookRepository.self)!,
                singleTickerRepository: resolver.resolve(SingleMarketTickerRepository.self)!,
                coinTradeRepository: resolver.resolve(CoinTradeRepository.self)!,
                exchangeRateRepository: resolver.resolve(ExchangeRateRepository.self)!
            )
        }
    }
}
