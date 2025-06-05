//
//  Ticker.swift
//  Domain
//
//  Created by choijunios on 6/5/25.
//

import Foundation

public struct Ticker {
    public let pairSymbol: String
    public var price: Decimal
    public let totalTradedQuoteAssetVolume: Decimal
    public let changedPercent: Decimal
    public let bestBidPrice: Decimal
    public let bestAskPrice: Decimal
    
    public init(
        pairSymbol: String,
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
