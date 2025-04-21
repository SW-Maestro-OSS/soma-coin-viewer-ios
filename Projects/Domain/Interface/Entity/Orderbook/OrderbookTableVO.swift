//
//  OrderbookTableVO.swift
//  Domain
//
//  Created by choijunios on 4/20/25.
//

public struct OrderbookTableVO {
    public let bidOrderbooks: [Orderbook]
    public let askOrderbooks: [Orderbook]
    
    public init(bidOrderbooks: [Orderbook], askOrderbooks: [Orderbook]) {
        self.bidOrderbooks = bidOrderbooks
        self.askOrderbooks = askOrderbooks
    }
}
