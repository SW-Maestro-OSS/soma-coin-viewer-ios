//
//  DefaultI18NManager.swift
//  I18N
//
//  Created by 최재혁 on 12/23/24.
//

import Foundation
import Combine
import I18NInterface
import DomainInterface
import CoreUtil

public class DefaultI18NManger : I18NManager {
    
    @Injected private var repository : UserConfigurationRepository
    
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
    
    public func getGridType() -> GridType {
        return repository.getGridType()
    }
    
    public func setGridType(type: GridType) {
        repository.setGrideType(type: type)
    }
    
    public func getExchangeRate(type: CurrencyType) {
        
    }
    
    public func setExchangeRate() {
        
    }
}
