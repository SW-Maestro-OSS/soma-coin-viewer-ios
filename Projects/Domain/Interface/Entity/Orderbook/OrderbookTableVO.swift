//
//  OrderbookTableVO.swift
//  Domain
//
//  Created by choijunios on 4/20/25.
//

public struct OrderbookTableVO2 {
    public let askOrderbooks: [Orderbook]
    public let bidOrderbooks: [Orderbook]
    
    public init(askOrderbooks: [Orderbook], bidOrderbooks: [Orderbook]) {
        self.askOrderbooks = askOrderbooks
        self.bidOrderbooks = bidOrderbooks
    }
}
