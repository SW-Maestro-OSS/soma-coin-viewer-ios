//
//  UserConfiguration.swift
//  Domain
//
//  Created by choijunios on 10/15/24.
//

import Foundation

public enum UserConfiguration {
    
    case currency
    case gridType
}

// MARK: Grid type
public enum GridType: String {
    case list="LIST"
    case twoByTwo="2X2"
    
    static let defaultValue: GridType = .list
}

// MARK: Currency
public enum CurrencyType: String {
    case won="WON"
    case dollar="DOLLAR"
    
    static let defaultValue: CurrencyType = .won
}
