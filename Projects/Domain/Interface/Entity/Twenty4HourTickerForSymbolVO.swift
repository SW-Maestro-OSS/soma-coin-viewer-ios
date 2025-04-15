//
//  Twenty4HourTickerForSymbolVO.swift
//  DomainInterface
//
//  Created by choijunios on 11/1/24.
//

import Foundation

import CoreUtil

public struct Twenty4HourTickerForSymbolVO {
    
    public let pairSymbol: String
    public var firstSymbol: String!
    public var secondSymbol: String!
    public let price: CVNumber
    public let totalTradedQuoteAssetVolume: CVNumber
    public let changedPercent: CVNumber
    public let bestBidPrice: CVNumber
    public let bestAskPrice: CVNumber
    
    public init(
        pairSymbol: String,
        price: CVNumber,
        totalTradedQuoteAssetVolume: CVNumber,
        changedPercent: CVNumber,
        bestBidPrice: CVNumber,
        bestAskPrice: CVNumber
    ) {
        self.pairSymbol = pairSymbol
        self.price = price
        self.totalTradedQuoteAssetVolume = totalTradedQuoteAssetVolume
        self.changedPercent = changedPercent
        self.bestBidPrice = bestBidPrice
        self.bestAskPrice = bestAskPrice
    }
    
    public mutating func setSymbols(closure: (String) -> (String, String)) {
        
        let (first, second) = closure(pairSymbol)
        
        self.firstSymbol = first
        self.secondSymbol = second
    }
}
