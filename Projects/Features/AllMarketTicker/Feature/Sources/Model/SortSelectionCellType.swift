//
//  SortSelectionCellType.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/23/25.
//

enum SortSelectionCellType: String, Identifiable {
    
    var id: String { self.rawValue }
    
    case symbol
    case price
    case changeIn24h
    
    enum ComparatorType {
        case ascending, descending
    }
    
    func getSortComparator(type: ComparatorType) -> TickerSortComparator {
        switch self {
        case .symbol:
            switch type {
            case .ascending:
                TickerSymbolAscendingComparator()
            case .descending:
                TickerSymbolDescendingComparator()
            }
        case .price:
            switch type {
            case .ascending:
                TickerPriceAscendingComparator()
            case .descending:
                TickerPriceDescendingComparator()
            }
        case .changeIn24h:
            switch type {
            case .ascending:
                Ticker24hChangeAscendingComparator()
            case .descending:
                Ticker24hChangeDescendingComparator()
            }
        }
        
    }
}
