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
    
    public var defaultSavingValue: String {
        switch self {
        case .currency:
            CurrencyType.dollar.savingValue
        case .gridType:
            GridType.list.savingValue
        }
    }
    
    public var savingKey: String {
        "configuration_\(self.rawValue)"
    }
}

// MARK: Grid type, 그리드 타입
public enum GridType: String {
    case list="LIST"
    case twoByTwo="2X2"

    public var savingValue: String {
        self.rawValue
    }
}

// MARK: Currency, 화폐 타입
public enum CurrencyType: String {
    case won="WON"
    case dollar="DOLLAR"
    
    public var savingValue: String {
        self.rawValue
    }
}
