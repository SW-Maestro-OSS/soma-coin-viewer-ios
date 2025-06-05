//
//  TickerNoneComparator.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import DomainInterface

struct TickerNoneComparator: TickerComparator {
    let id: String = .init(describing: TickerNoneComparator.self)
    func compare(lhs: Ticker, rhs: Ticker) -> Bool { true }
}
