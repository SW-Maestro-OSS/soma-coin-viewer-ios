//
//  StubUserConfigurationRepository.swift
//  Domain
//
//  Created by choijunios on 4/24/25.
//

import DomainInterface

public struct StubUserConfigurationRepository: UserConfigurationRepository {
    
    public init() { }
    
    public func getCurrencyType() -> DomainInterface.CurrencyType {
        return .dollar
    }
    
    public func setCurrencyType(type: DomainInterface.CurrencyType) {
        
    }
    
    public func getLanguageType() -> DomainInterface.LanguageType {
        return .english
    }
    
    public func setLanguageType(type: DomainInterface.LanguageType) {
        
    }
    
    public func getGridType() -> DomainInterface.GridType {
        return .list
    }
    
    public func setGridType(type: DomainInterface.GridType) {
        
    }
}
