//
//  TickerSortComparator.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/29/24.
//

import DomainInterface

public protocol TickerSortComparator {
    
    typealias TickerVO = Twenty4HourTickerForSymbolVO
    
    var id: String { get }
    
    func compare(lhs: TickerVO, rhs: TickerVO) -> Bool
}
