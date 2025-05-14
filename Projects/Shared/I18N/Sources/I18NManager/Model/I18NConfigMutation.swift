//
//  I18NConfigMutation.swift
//  I18N
//
//  Created by choijunios on 1/14/25.
//

import DomainInterface

public struct I18NConfigMutation {
    
    public var languageType: LanguageType?
    public var currencyType: CurrencyType?
    
    public init(languageType: LanguageType? = nil, currencyType: CurrencyType? = nil) {
        self.languageType = languageType
        self.currencyType = currencyType
    }
}
