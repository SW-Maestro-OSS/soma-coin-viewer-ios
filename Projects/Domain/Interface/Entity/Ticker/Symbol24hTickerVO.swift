//
//  Symbol24hTickerVO.swift
//  DomainInterface
//
//  Created by choijunios on 11/1/24.
//

import Foundation

public struct Symbol24hTickerVO {
    
    public let symbol: String
    public let price: Double
    public let totalTradedQuoteAssetVolume: Double
    public let changedPercent: Double
    
    public init(symbol: String, price: Double, totalTradedQuoteAssetVolume: Double, changedPercent: Double) {
        self.symbol = symbol
        self.price = price
        self.totalTradedQuoteAssetVolume = totalTradedQuoteAssetVolume
        self.changedPercent = changedPercent
    }
}
