//
//  TickerSortSelectorViewModelDelegate.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/10/24.
//

protocol TickerSortSelectorViewModelDelegate: AnyObject {
    
    func sortSelector(selection comparator: any TickerSortComparator)
}
