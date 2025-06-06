//
//  CurrencyType.swift
//  Domain
//
//  Created by choijunios on 1/13/25.
//

public enum CurrencyType: String, CaseIterable {
    //필요 화폐 타입 추가 가능
    case won="WON"
    case dollar="DOLLAR"
    
    /// 도메인 기본값
    public static var defaultValue: Self { .dollar }
    
    public var currencyCode: String {
        switch self {
        case .won:
            "KRW"
        case .dollar:
            "USD"
        }
    }
    
    public var symbol: String {
        switch self {
        case .won:
            "₩"
        case .dollar:
            "$"
        }
    }
    
    public var isPrefix: Bool {
        switch self {
        case .won:
            false
        case .dollar:
            true
        }
    }
}
