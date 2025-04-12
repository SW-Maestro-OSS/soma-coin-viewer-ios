//
//  OrderbookUpdateVO.swift
//  Domain
//
//  Created by choijunios on 4/12/25.
//

public struct OrderbookUpdateVO {
    public struct Order {
        public let price: Double
        public let quantity: Double
        public init(price: Double, quantity: Double) {
            self.price = price
            self.quantity = quantity
        }
    }
    public let bids: [Order]
    public let asks: [Order]
    public let lastUpdateId: Int
    
    public init(bids: [Order], asks: [Order], lastUpdateId: Int) {
        self.bids = bids
        self.asks = asks
        self.lastUpdateId = lastUpdateId
    }
}
