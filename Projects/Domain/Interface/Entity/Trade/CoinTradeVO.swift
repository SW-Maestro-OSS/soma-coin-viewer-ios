//
//  CoinTradeVO.swift
//  Domain
//
//  Created by choijunios on 4/15/25.
//

import Foundation

import CoreUtil

public struct CoinTradeVO {
    public let price: CVNumber
    public let quantity: CVNumber
    public let tradeTime: Date
    
    public init(price: CVNumber, quantity: CVNumber, tradeTime: Date) {
        self.price = price
        self.quantity = quantity
        self.tradeTime = tradeTime
    }
}
