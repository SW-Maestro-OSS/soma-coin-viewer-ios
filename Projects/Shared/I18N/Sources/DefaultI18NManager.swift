//
//  DefaultI18NManager.swift
//  I18N
//
//  Created by 최재혁 on 12/23/24.
//

import Foundation
import Combine

import DomainInterface

import CoreUtil

public class DefaultI18NManager: I18NManager {
    // Dependency
    @Injected private var repository : UserConfigurationRepository
    
    private let changePublisher: PassthroughSubject<I18NConfigMutation, Never> = .init()
    
    public init() { }
    
    
    public func getChangePublisher() -> AnyPublisher<I18NConfigMutation, Never> {
        changePublisher.eraseToAnyPublisher()
    }
    
    
    public func getCurrencyType() -> CurrencyType {
        return repository.getCurrencyType()
    }
    
    
    public func setCurrencyType(type: CurrencyType) {
        repository.setCurrencyType(type: type)
        changePublisher.send(.init(currencyType: type))
    }
    
    
    public func getLanguageType() -> LanguageType {
        return repository.getLanguageType()
    }
    
    
    public func setLanguageType(type: LanguageType) {
        repository.setLanguageType(type: type)
        changePublisher.send(.init(languageType: type))
    }
}
