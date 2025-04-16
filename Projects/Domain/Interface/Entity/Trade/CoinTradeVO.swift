//
//  CoinTradeVO.swift
//  Domain
//
//  Created by choijunios on 4/15/25.
//

import Foundation

import CoreUtil

public struct CoinTradeVO: Sendable {
    public enum TradeType: Sendable {
        case buy, sell
    }
    
    public let tradeId: String
    public let tradeType: TradeType
    public let price: CVNumber
    public let quantity: CVNumber
    public let tradeTime: Date
    
    public init(tradeId: String, tradeType: TradeType, price: CVNumber, quantity: CVNumber, tradeTime: Date) {
        self.tradeId = tradeId
        self.tradeType = tradeType
        self.price = price
        self.quantity = quantity
        self.tradeTime = tradeTime
    }
}
