//
//  TickerNoneComparator.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

struct TickerNoneComparator: TickerSortComparator {
    
    let id: String = .init(describing: TickerNoneComparator.self)
    
    func compare(lhs: TickerVO, rhs: TickerVO) -> Bool {
        true
    }
    
}
