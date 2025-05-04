//
//  DefaultUserConfigurationRepository.swift
//  Repository
//
//  Created by choijunios on 10/15/24.
//

import Foundation

import DataSource
import DomainInterface
import CoreUtil

public class DefaultUserConfigurationRepository: UserConfigurationRepository {
    // Dependency
    @Injected private var dataSource: UserConfigurationDataSource
    
    public init() { }
}


// MARK: UserConfigurationRepository
public extension DefaultUserConfigurationRepository {
    func getCurrencyType() -> CurrencyType? {
        guard let value = dataSource.getCurrency() else { return nil }
        return CurrencyType(rawValue: value)
    }
    func setCurrencyType(type: CurrencyType) {
        dataSource.setCurrency(type: type.rawValue)
    }
    
    func getLanguageType() -> LanguageType? {
        guard let value = dataSource.getLanguageType() else { return nil }
        return LanguageType(rawValue: value)
    }
    func setLanguageType(type: LanguageType) {
        dataSource.setLanguageType(type: type.rawValue)
    }
    
    func getGridType() -> GridType? {
        guard let value = dataSource.getGridType() else { return nil }
        return GridType(rawValue: value)
    }
    func setGridType(type: GridType) {
        dataSource.setLanguageType(type: type.rawValue)
    }
}
