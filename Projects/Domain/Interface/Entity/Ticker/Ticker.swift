//
//  Ticker.swift
//  Domain
//
//  Created by choijunios on 6/5/25.
//

import Foundation

public struct PairSymbol {
    public let firstSymbol: String
    public let secondSymbol: String
    public var fullSymbol: String { firstSymbol + secondSymbol }
    
    public init(firstSymbol: String, secondSymbol: String) {
        self.firstSymbol = firstSymbol
        self.secondSymbol = secondSymbol
    }
}

public struct Ticker {
    public let pairSymbol: PairSymbol
    public var price: Decimal
    public let totalTradedQuoteAssetVolume: Decimal
    public let changedPercent: Decimal
    public let bestBidPrice: Decimal
    public let bestAskPrice: Decimal
    
    public init(
        pairSymbol: PairSymbol,
        price: Decimal,
        totalTradedQuoteAssetVolume: Decimal,
        changedPercent: Decimal,
        bestBidPrice: Decimal,
        bestAskPrice: Decimal
    ) {
        self.pairSymbol = pairSymbol
        self.price = price
        self.totalTradedQuoteAssetVolume = totalTradedQuoteAssetVolume
        self.changedPercent = changedPercent
        self.bestBidPrice = bestBidPrice
        self.bestAskPrice = bestAskPrice
    }
}
