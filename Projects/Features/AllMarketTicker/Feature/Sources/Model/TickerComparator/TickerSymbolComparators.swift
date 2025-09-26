//
//  TickerSymbolComparators.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import DomainInterface

// MARK: Symbol

struct TickerSymbolAscendingComparator: TickerComparator {
    let id: String = String(describing: TickerSymbolAscendingComparator.self)
    func compare(lhs: Ticker, rhs: Ticker) -> Bool {
        lhs.pairSymbol.fullSymbol.uppercased() < rhs.pairSymbol.fullSymbol.uppercased()
    }
}

struct TickerSymbolDescendingComparator: TickerComparator {
    let id: String = String(describing: TickerSymbolDescendingComparator.self)
    func compare(lhs: Ticker, rhs: Ticker) -> Bool {
        lhs.pairSymbol.fullSymbol.uppercased() > rhs.pairSymbol.fullSymbol.uppercased()
    }
}

// MARK: Price

struct TickerPriceAscendingComparator: TickerComparator {
    let id: String = String(describing: TickerPriceAscendingComparator.self)
    func compare(lhs: Ticker, rhs: Ticker) -> Bool {
        lhs.price < rhs.price
    }
}

struct TickerPriceDescendingComparator: TickerComparator {
    let id: String = String(describing: TickerPriceDescendingComparator.self)
    func compare(lhs: Ticker, rhs: Ticker) -> Bool {
        lhs.price > rhs.price
    }
}

// MARK: 24hChangePercent

struct Ticker24hChangeAscendingComparator: TickerComparator {
    let id: String = String(describing: Ticker24hChangeAscendingComparator.self)
    func compare(lhs: Ticker, rhs: Ticker) -> Bool {
        lhs.changedPercent < rhs.changedPercent
    }
}

struct Ticker24hChangeDescendingComparator: TickerComparator {
    let id: String = String(describing: Ticker24hChangeDescendingComparator.self)
    func compare(lhs: Ticker, rhs: Ticker) -> Bool {
        
        lhs.changedPercent > rhs.changedPercent
    }
}

