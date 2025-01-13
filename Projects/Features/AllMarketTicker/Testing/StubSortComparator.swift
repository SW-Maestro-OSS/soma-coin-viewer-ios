//
//  StubSortComparator.swift
//
//

import Foundation

import AllMarketTickerFeature

struct StubSortComparator: TickerSortComparator {
    
    var id: String
    
    init(id: String = "test-comparator") {
        self.id = id
    }
    
    func compare(lhs: TickerVO, rhs: TickerVO) -> Bool {
        
        lhs.price < rhs.price
    }
}



