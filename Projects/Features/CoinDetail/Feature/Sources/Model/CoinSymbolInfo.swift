//
//  CoinSymbolInfo.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/17/25.
//

public struct CoinSymbolInfo: Hashable {
    public let firstSymbol: String
    public let secondSymbol: String
    
    var pairSymbol: String { firstSymbol+secondSymbol }
    
    public init(firstSymbol: String, secondSymbol: String) {
        self.firstSymbol = firstSymbol
        self.secondSymbol = secondSymbol
    }
}
