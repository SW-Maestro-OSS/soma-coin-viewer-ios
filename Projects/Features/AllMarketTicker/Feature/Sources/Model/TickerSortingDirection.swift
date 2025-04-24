//
//  TickerSortingDirection.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 4/24/25.
//

enum TickerSortingDirection {
    case neutral
    case ascending
    case descending
    
    func nextDirectionOnTap() -> Self {
        switch self {
        case .neutral:
            .descending
        case .ascending:
            .descending
        case .descending:
            .ascending
        }
    }
}
