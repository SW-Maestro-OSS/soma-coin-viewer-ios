//
//  OrderbookTable.swift
//  Domain
//
//  Created by choijunios on 4/20/25.
//

import CoreUtil

public struct OrderbookTable {
    public let bidOrderbooks: HashMap<CVNumber, CVNumber>
    public let askOrderbooks: HashMap<CVNumber, CVNumber>
    
    public init(bidOrderbooks: HashMap<CVNumber, CVNumber>, askOrderbooks: HashMap<CVNumber, CVNumber>) {
        self.bidOrderbooks = bidOrderbooks
        self.askOrderbooks = askOrderbooks
    }
}
