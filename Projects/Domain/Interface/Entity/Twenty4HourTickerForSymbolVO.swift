//
//  Twenty4HourTickerForSymbolVO.swift
//  DomainInterface
//
//  Created by choijunios on 11/1/24.
//

import Foundation

public struct Twenty4HourTickerForSymbolVO {
    
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
