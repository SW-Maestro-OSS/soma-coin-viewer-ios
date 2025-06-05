//
//  TickerSortComparator.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/29/24.
//

import DomainInterface

protocol TickerComparator {
    var id: String { get }
    func compare(lhs: Ticker, rhs: Ticker) -> Bool
}
