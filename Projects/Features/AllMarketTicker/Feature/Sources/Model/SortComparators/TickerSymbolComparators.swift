//
//  TickerSymbolComparators.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import DomainInterface

// MARK: Symbol

struct TickerSymbolAscendingComparator: TickerSortComparator {
    
    let id: String = String(describing: TickerSymbolAscendingComparator.self)
    
    func compare(lhs: TickerVO, rhs: TickerVO) -> Bool {
        
        lhs.pairSymbol < rhs.pairSymbol
    }
}

struct TickerSymbolDescendingComparator: TickerSortComparator {
    
    let id: String = String(describing: TickerSymbolDescendingComparator.self)
    
    func compare(lhs: TickerVO, rhs: TickerVO) -> Bool {
        
        lhs.pairSymbol > rhs.pairSymbol
    }
}

// MARK: Price

struct TickerPriceAscendingComparator: TickerSortComparator {
    
    let id: String = String(describing: TickerPriceAscendingComparator.self)
    
    func compare(lhs: TickerVO, rhs: TickerVO) -> Bool {
        
        lhs.price < rhs.price
    }
}

struct TickerPriceDescendingComparator: TickerSortComparator {
    
    let id: String = String(describing: TickerPriceDescendingComparator.self)
    
    func compare(lhs: TickerVO, rhs: TickerVO) -> Bool {
        
        lhs.price > rhs.price
    }
}

// MARK: 24hChangePercent

struct Ticker24hChangeAscendingComparator: TickerSortComparator {
    
    let id: String = String(describing: Ticker24hChangeAscendingComparator.self)
    
    func compare(lhs: TickerVO, rhs: TickerVO) -> Bool {
        
        lhs.changedPercent < rhs.changedPercent
    }
}

struct Ticker24hChangeDescendingComparator: TickerSortComparator {
    
    let id: String = String(describing: Ticker24hChangeDescendingComparator.self)
    
    func compare(lhs: TickerVO, rhs: TickerVO) -> Bool {
        
        lhs.changedPercent > rhs.changedPercent
    }
}

