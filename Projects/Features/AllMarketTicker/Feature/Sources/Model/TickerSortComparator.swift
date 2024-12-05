//
//  TickerSortComparator.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/5/24.
//

import DomainInterface

protocol TickerSortComparator: Identifiable {
    
    typealias TickerVO = Twenty4HourTickerForSymbolVO
    
    func compare(lhs: TickerVO, rhs: TickerVO) -> Bool
}
