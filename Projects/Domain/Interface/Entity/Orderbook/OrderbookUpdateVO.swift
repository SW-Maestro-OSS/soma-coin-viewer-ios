//
//  OrderbookUpdateVO.swift
//  Domain
//
//  Created by choijunios on 4/12/25.
//

import CoreUtil

public struct Orderbook: Sendable {
    public let price: CVNumber
    public let quantity: CVNumber
    public init(price: CVNumber, quantity: CVNumber) {
        self.price = price
        self.quantity = quantity
    }
}

public struct OrderbookUpdateVO: Sendable {
    public let bids: [Orderbook]
    public let asks: [Orderbook]
    public let lastUpdateId: Int
    
    public init(bids: [Orderbook], asks: [Orderbook], lastUpdateId: Int) {
        self.bids = bids
        self.asks = asks
        self.lastUpdateId = lastUpdateId
    }
}
