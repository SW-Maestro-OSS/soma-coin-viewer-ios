//
//  Assemblies.swift
//  AllMarketTickerFeatureExample
//
//  Created by choijunios on 11/1/24.
//

import Foundation

@testable import AllMarketTickerFeatureTesting

import DataSource
import Repository

import DomainInterface
import Domain

import WebSocketManagementHelper
import I18N

import Swinject

public class Assemblies: Assembly {
    
    public func assemble(container: Swinject.Container) {
        
        // MARK: DataSource
        container.register(UserConfigurationService.self) { _ in
            DefaultUserConfigurationService()
        }
        container.register(ExchangeRateService.self) { _ in
            DefaultExchangeRateService()
        }
        container.register(WebSocketService.self) { _ in
            BinanceWebSocketService()
        }
        .inObjectScope(.container)
        
        
        // MARK: Shared
        container.register(WebSocketManagementHelper.self) { resolver in
            DefaultWebSocketManagementHelper(
                webSocketService: resolver.resolve(WebSocketService.self)!
            )
        }
        .inObjectScope(.container)
        
        container.register(I18NManager.self) { _ in
            DefaultI18NManager()
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
        container.register(ExchangeRateRepository.self) { _ in
            DefaultExchangeRateRepository()
        }
        container.register(LanguageLocalizationRepository.self) { _ in
            DefaultLanguageLocalizationRepository()
        }
        
        
        // MARK: UseCase
        container.register(AllMarketTickersUseCase.self) { _ in
            DefaultAllMarketTickersUseCase()
        }
        container.register(ExchangeRateUseCase.self) { _ in
            FakeExchangeRateUseCase()
        }
    }
}
