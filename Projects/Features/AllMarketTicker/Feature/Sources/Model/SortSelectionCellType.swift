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
    
    static var orderedList: [Self] {
        [.symbol, .price, .changeIn24h]
    }
    
    func getComparator(direction: TickerSortingDirection) -> TickerComparator {
        switch direction {
        case .neutral:
            TickerNoneComparator()
        case .ascending:
            switch self {
            case .symbol:
                TickerSymbolAscendingComparator()
            case .price:
                TickerPriceAscendingComparator()
            case .changeIn24h:
                Ticker24hChangeAscendingComparator()
            }
        case .descending:
            switch self {
            case .symbol:
                TickerSymbolDescendingComparator()
            case .price:
                TickerPriceDescendingComparator()
            case .changeIn24h:
                Ticker24hChangeDescendingComparator()
            }
        }
    }
    
    var displayTextKey: String {
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
