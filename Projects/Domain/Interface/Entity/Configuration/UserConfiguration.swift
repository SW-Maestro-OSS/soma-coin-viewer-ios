//
//  UserConfiguration.swift
//  Domain
//
//  Created by choijunios on 10/15/24.
//

import Foundation

/// 설정 옵션의 종류를 의미합니다.
public enum UserConfiguration: String {
    
    case currency
    case gridType
    case language
    
    public var defaultSavingValue: String {
        switch self {
        case .currency:
            CurrencyType.dollar.savingValue
        case .gridType:
            GridType.list.savingValue
        case .language:
            LanguageType.english.savingValue
        }
    }
    
    public var savingKey: String {
        "configuration_\(self.rawValue)"
    }
}
