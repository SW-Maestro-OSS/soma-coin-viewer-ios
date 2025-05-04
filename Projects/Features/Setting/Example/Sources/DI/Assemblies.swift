//
//  Assemblies.swift
//  SettingModule
//
//  Created by 최재혁 on 1/10/25.
//

import I18N

import DomainInterface
import Domain

import Repository
import DataSource

import Swinject

public class Assemblies : Assembly {
    public func assemble(container: Container) {
        // MARK: Service
        container.register(KeyValueStoreService.self) { _ in
            DefaultKeyValueStoreService()
        }
        .inObjectScope(.container)
        
        //MARK: DataSource
        container.register(ExchangeRateDataSource.self) { _ in
            OpenXExchangeRateDataSource()
        }
        .inObjectScope(.container)
        container.register(UserConfigurationDataSource.self) { resolver in
            DefaultUserConfigurationDataSource()
        }
        .inObjectScope(.container)
        
        
        // MARK: Repository
        container.register(ExchangeRateRepository.self) { _ in
            DefaultExchangeRateRepository()
        }
        container.register(UserConfigurationRepository.self) { _ in
            DefaultUserConfigurationRepository()
        }
        
        
        // MARK: UseCase
        container.register(SettingPageUseCase.self) { resolver in
            DefaultSettingPageUseCase(
                repository: resolver.resolve(UserConfigurationRepository.self)!
            )
        }
        
        
        //MARK: I18N
        container.register(I18NManager.self) { resolver in
            DefaultI18NManager(
                repository: resolver.resolve(UserConfigurationRepository.self)!
            )
        }
    }
}
