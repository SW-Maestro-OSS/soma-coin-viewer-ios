//
//  TickerNoneComparator.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

struct TickerNoneComparator: TickerComparator {
    let id: String = .init(describing: TickerNoneComparator.self)
    func compare(lhs: TickerCellRO, rhs: TickerCellRO) -> Bool { true }
}
