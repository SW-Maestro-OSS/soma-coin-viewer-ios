//
//  FakeI18NManager.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/16/25.
//

import Combine

import I18N
import DomainInterface

class FakeI18NManager: I18NManager {
    
    let fakeUserConfigRepository = FakeUserConfigurationRepository()
    private let changePublisher: PassthroughSubject<I18NConfigMutation, Never> = .init()
    
    public func getChangePublisher() -> AnyPublisher<I18NConfigMutation, Never> {
        changePublisher.eraseToAnyPublisher()
    }
    
    func getCurrencyType() -> DomainInterface.CurrencyType {
        fakeUserConfigRepository.getCurrencyType()
    }
    
    func setCurrencyType(type: DomainInterface.CurrencyType) {
        fakeUserConfigRepository.setCurrencyType(type: type)
        changePublisher.send(.init(currencyType: type))
    }
    
    func getLanguageType() -> DomainInterface.LanguageType {
        fakeUserConfigRepository.getLanguageType()
    }
    
    func setLanguageType(type: DomainInterface.LanguageType) {
        fakeUserConfigRepository.setLanguageType(type: type)
        changePublisher.send(.init(languageType: type))
    }
}
