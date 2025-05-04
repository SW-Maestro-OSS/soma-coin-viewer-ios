//
//  FakeUserConfigurationRepository.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/13/25.
//

import DomainInterface

public final class FakeUserConfigurationRepository: UserConfigurationRepository {
    
    private var fakeDB: [String: String] = [:]
    
    public init() { }
    
    public func getCurrencyType() -> CurrencyType? {
        let value = fakeDB["currency"]!
        return .init(rawValue: value)!
    }
    
    public func setCurrencyType(type: CurrencyType) {
        fakeDB["currency"] = type.rawValue
    }
    
    public func getLanguageType() -> LanguageType? {
        let value = fakeDB["language"]!
        return .init(rawValue: value)!
    }
    
    public func setLanguageType(type: LanguageType) {
        fakeDB["language"] = type.rawValue
    }
    
    public func getGridType() -> GridType? {
        let value = fakeDB["gridType"]!
        return .init(rawValue: value)!
    }
    
    public func setGridType(type: GridType) {
        fakeDB["gridType"] = type.rawValue
    }
}
