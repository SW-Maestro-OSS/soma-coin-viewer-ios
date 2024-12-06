//
//  Twenty4HourTickerForSymbolVO.swift
//  DomainInterface
//
//  Created by choijunios on 11/1/24.
//

import Foundation

import CoreUtil

public struct Twenty4HourTickerForSymbolVO {
    
    public let symbol: String
    public let price: CVNumber
    public let totalTradedQuoteAssetVolume: CVNumber
    public let changedPercent: CVNumber
    
    public init(symbol: String, price: CVNumber, totalTradedQuoteAssetVolume: CVNumber, changedPercent: CVNumber) {
        self.symbol = symbol
        self.price = price
        self.totalTradedQuoteAssetVolume = totalTradedQuoteAssetVolume
        self.changedPercent = changedPercent
    }
}
