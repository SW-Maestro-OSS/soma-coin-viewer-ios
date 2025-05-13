//
//  DomainAssembly.swift
//  CoinViewer
//
//  Created by choijunios on 11/2/24.
//

import Repository
import DomainInterface
import Domain

import Swinject

class DomainAssembly: Assembly {
    
    func assemble(container: Swinject.Container) {
        // UseCase
        container.register(SettingPageUseCase.self) { resolver in
            DefaultSettingPageUseCase(
                repository: resolver.resolve(UserConfigurationRepository.self)!
            )
        }
        
        container.register(RootPageUseCase.self) { _ in
            DefaultRootPageUseCase()
        }
        
        container.register(AllMarketTickersUseCase.self) { resolver in
            DefaultAllMarketTickersUseCase(
                allMarketTickersRepository: resolver.resolve(AllMarketTickersRepository.self)!,
                exchangeRateRepository: resolver.resolve(ExchangeRateRepository.self)!,
                userConfigurationRepository: resolver.resolve(UserConfigurationRepository.self)!
            )
        }
        
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
