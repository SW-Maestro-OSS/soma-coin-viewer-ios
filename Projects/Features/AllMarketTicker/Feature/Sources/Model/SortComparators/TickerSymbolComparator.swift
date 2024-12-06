//
//  TickerSymbolComparator.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import DomainInterface

struct TickerSymbolAscendingComparator: TickerSortComparator {
    
    let id: String = String(describing: TickerSymbolAscendingComparator.self)
    
    func compare(lhs: TickerVO, rhs: TickerVO) -> Bool {
        
        lhs.symbol < rhs.symbol
    }
}

struct TickerSymbolDescendingComparator: TickerSortComparator {
    
    let id: String = String(describing: TickerSymbolDescendingComparator.self)
    
    func compare(lhs: TickerVO, rhs: TickerVO) -> Bool {
        
        lhs.symbol > rhs.symbol
    }
}
