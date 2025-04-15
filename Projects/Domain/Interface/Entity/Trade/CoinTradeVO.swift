//
//  CoinTradeVO.swift
//  Domain
//
//  Created by choijunios on 4/15/25.
//

import Foundation

public struct CoinTradeVO {
    public let price: Decimal
    public let quantity: Decimal
    public let tradeTime: Date
    
    public init(price: Decimal, quantity: Decimal, tradeTime: Date) {
        self.price = price
        self.quantity = quantity
        self.tradeTime = tradeTime
    }
}
