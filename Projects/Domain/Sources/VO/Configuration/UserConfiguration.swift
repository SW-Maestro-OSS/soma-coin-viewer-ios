//
//  UserConfiguration.swift
//  Domain
//
//  Created by choijunios on 10/15/24.
//

import Foundation

public enum UserConfiguration: String {
    
    case currency
    case gridType
    
    public var savingKey: String {
        "configuration_\(self.rawValue)"
    }
}

// MARK: Grid type
public enum GridType: String {
    case list="LIST"
    case twoByTwo="2X2"
    
    public static let defaultValue: GridType = .list
    
    public var savingValue: String {
        self.rawValue
    }
}

// MARK: Currency
public enum CurrencyType: String {
    case won="WON"
    case dollar="DOLLAR"
    
    public static let defaultValue: CurrencyType = .won
    
    public var savingValue: String {
        self.rawValue
    }
}
