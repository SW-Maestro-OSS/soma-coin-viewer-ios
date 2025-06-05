//
//  FakeUserConfigurationRepository.swift
//  Domain
//
//  Created by choijunios on 4/24/25.
//

import DomainInterface

public class FakeUserConfigurationRepository: UserConfigurationRepository {
    private var currencyType: CurrencyType
    private var languageType: LanguageType
    private var gridType: GridType
    
    public init(
        currencyType: CurrencyType = .dollar,
        languageType: LanguageType = .korean,
        gridType: GridType = .list
    ) {
        self.currencyType = currencyType
        self.languageType = languageType
        self.gridType = gridType
    }
    
    public func getCurrencyType() -> DomainInterface.CurrencyType? {
        return currencyType
    }
    
    public func setCurrencyType(type: DomainInterface.CurrencyType) {
        self.currencyType = type
    }
    
    public func getLanguageType() -> DomainInterface.LanguageType? {
        return languageType
    }
    
    public func setLanguageType(type: DomainInterface.LanguageType) {
        self.languageType = type
    }
    
    public func getGridType() -> DomainInterface.GridType? {
        return gridType
    }
    
    public func setGridType(type: DomainInterface.GridType) {
        self.gridType = type
    }
}
