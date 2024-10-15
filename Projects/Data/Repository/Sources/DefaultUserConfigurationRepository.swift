//
//  DefaultUserConfigurationRepository.swift
//  Repository
//
//  Created by choijunios on 10/15/24.
//

import Foundation
import DataSource
import Domain
import CoreUtil

public class DefaultUserConfigurationRepository: UserConfigurationRepository {
    
    // DI
    @Injected var userConfigurationService: UserConfigurationService
    
    public init() { }
    
    public func getCurrencyType() -> CurrencyType {
        let key: UserConfiguration = .currency
        
        guard let currencyString = userConfigurationService
            .getConfiguration(key: key.savingKey) else {
            
            return .defaultValue
        }
        
        return .init(rawValue: currencyString)!
    }
    
    public func setCurrencyType(type: Domain.CurrencyType) {
        let key: UserConfiguration = .currency
        userConfigurationService.setConfiguration(key: key.savingKey, value: type.savingValue)
    }
    
    public func getGridType() -> Domain.GridType {
        
        let key: UserConfiguration = .gridType
        
        guard let gridString = userConfigurationService
            .getConfiguration(key: key.savingKey) else {
            
            return .defaultValue
        }
        
        return .init(rawValue: gridString)!
    }
    
    public func setGrideType(type: Domain.GridType) {
        let key: UserConfiguration = .gridType
        userConfigurationService.setConfiguration(key: key.savingKey, value: type.savingValue)
    }
}
