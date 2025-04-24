//
//  OrderbookTable.swift
//  Domain
//
//  Created by choijunios on 4/20/25.
//

import CoreUtil

public struct OrderbookTable {
    public typealias Price = CVNumber
    public typealias Quantity = CVNumber
    
    public let bidOrderbooks: HashMap<Price, Quantity>
    public let askOrderbooks: HashMap<Price, Quantity>
    
    public init(bidOrderbooks: HashMap<Price, Quantity>, askOrderbooks: HashMap<Price, Quantity>) {
        self.bidOrderbooks = bidOrderbooks
        self.askOrderbooks = askOrderbooks
    }
}
