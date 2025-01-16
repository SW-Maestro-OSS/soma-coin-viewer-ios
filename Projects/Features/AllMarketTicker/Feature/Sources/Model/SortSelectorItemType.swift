//
//  SortSelectorItemType.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/14/25.
//

enum SortSelectorItemType: String, Identifiable {
    
    var id: String { self.rawValue }
    
    case symbol
    case price
    case changeIn24h
    
    
    // Ascending comparators
    var ascending: TickerSortComparator {
        switch self {
        case .symbol:
            TickerSymbolAscendingComparator()
        case .price:
            TickerPriceAscendingComparator()
        case .changeIn24h:
            Ticker24hChangeAscendingComparator()
        }
    }
    
    
    // Descending comparators
    var descending: TickerSortComparator {
        switch self {
        case .symbol:
            TickerSymbolDescendingComparator()
        case .price:
            TickerPriceDescendingComparator()
        case .changeIn24h:
            Ticker24hChangeDescendingComparator()
        }
    }
    
    
    // Key for I18N text
    var titleTextKey: String {
        
        switch self {
        case .symbol:
            "AllMarketTickerPage_comparator_symbol"
        case .price:
            "AllMarketTickerPage_comparator_price"
        case .changeIn24h:
            "AllMarketTickerPage_comparator_24hchange"
        }
    }
}
