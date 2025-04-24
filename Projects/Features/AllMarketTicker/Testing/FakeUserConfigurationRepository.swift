//
//  FakeUserConfigurationRepository.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/13/25.
//

import DomainInterface

public final class FakeUserConfigurationRepository: UserConfigurationRepository {
    
    private var fakeDB: [String: String] = [
        UserConfiguration.currency.savingKey: CurrencyType.dollar.savingValue,
        UserConfiguration.language.savingKey: LanguageType.english.savingValue,
        UserConfiguration.gridType.savingKey: GridType.list.savingValue
    ]
    
    public init() { }
    
    public func getCurrencyType() -> DomainInterface.CurrencyType {
        let value = fakeDB[UserConfiguration.currency.savingKey]!
        return .init(rawValue: value)!
    }
    
    public func setCurrencyType(type: DomainInterface.CurrencyType) {
        fakeDB[UserConfiguration.currency.savingKey] = type.savingValue
    }
    
    public func getLanguageType() -> DomainInterface.LanguageType {
        let value = fakeDB[UserConfiguration.language.savingKey]!
        return .init(rawValue: value)!
    }
    
    public func setLanguageType(type: DomainInterface.LanguageType) {
        fakeDB[UserConfiguration.language.savingKey] = type.savingValue
    }
    
    public func getGridType() -> DomainInterface.GridType {
        let value = fakeDB[UserConfiguration.gridType.savingKey]!
        return .init(rawValue: value)!
    }
    
    public func setGrideType(type: DomainInterface.GridType) {
        fakeDB[UserConfiguration.gridType.savingKey] = type.savingValue
    }
}
