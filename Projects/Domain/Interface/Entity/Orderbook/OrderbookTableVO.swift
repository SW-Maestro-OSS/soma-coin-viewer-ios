//
//  OrderbookTableVO.swift
//  Domain
//
//  Created by choijunios on 4/20/25.
//

import CoreUtil

public struct OrderbookTableVO {
    public let askOrderbooks: HashMap<CVNumber, CVNumber>
    public let bidOrderbooks: HashMap<CVNumber, CVNumber>
    
    public init(askOrderbooks: HashMap<CVNumber, CVNumber>, bidOrderbooks: HashMap<CVNumber, CVNumber>) {
        self.askOrderbooks = askOrderbooks
        self.bidOrderbooks = bidOrderbooks
    }
}
