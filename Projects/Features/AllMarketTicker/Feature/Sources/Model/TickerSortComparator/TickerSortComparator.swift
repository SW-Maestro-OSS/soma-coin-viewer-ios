//
//  TickerSortComparator.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/29/24.
//

import DomainInterface

protocol TickerSortComparator {
    var id: String { get }
    func compare(lhs: TickerCellRO, rhs: TickerCellRO) -> Bool
}
