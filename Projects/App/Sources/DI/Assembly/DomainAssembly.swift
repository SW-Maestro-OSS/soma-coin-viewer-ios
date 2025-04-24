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
        
        container.register(CoinDetailPageUseCase.self) { _ in
            DefaultCoinDetailPageUseCase()
        }
    }
}
