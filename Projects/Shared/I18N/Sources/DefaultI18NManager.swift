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

public class DefaultI18NManager : I18NManager {
    
    @Injected private var repository : UserConfigurationRepository
    
    private var store: Set<AnyCancellable> = .init()
    
    public init() { }
    
    public func getCurrencyType() -> CurrencyType {
        return repository.getCurrencyType()
    }
    
    public func setCurrencyType(type: CurrencyType) {
        repository.setCurrencyType(type: type)
    }
    
    public func getLanguageType() -> LanguageType {
        return repository.getLanguageType()
    }
    
    public func setLanguageType(type: LanguageType) {
        repository.setLanguageType(type: type)
    }
}
