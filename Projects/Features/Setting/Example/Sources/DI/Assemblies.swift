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
        //MARK: DataSource
        container.register(ExchangeRateService.self) { _ in
            DefaultExchangeRateService()
        }
        
        container.register(ExchangeRateRepository.self) { _ in
            DefaultExchangeRateRepository()
        }
        
        container.register(ExchangeRateUseCase.self) { _ in
            DefaultExchangeRateUseCase()
        }
        
        container.register(UserConfigurationService.self) { _ in
            DefaultUserConfigurationService()
        }
        
        container.register(UserConfigurationRepository.self) { _ in
            DefaultUserConfigurationRepository()
        }
        
        //MARK: I18N
        container.register(I18NManager.self) { _ in
            DefaultI18NManager()
        }
        
        //MARK: LanguageLocalizationRepository
        container.register(LanguageLocalizationRepository.self) { _ in
            DefaultLanguageLocalizationRepository()
        }
    }
}
