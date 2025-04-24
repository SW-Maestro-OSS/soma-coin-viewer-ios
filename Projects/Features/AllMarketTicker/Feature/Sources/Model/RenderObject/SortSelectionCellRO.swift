//
//  SortSelectionCellRO.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/23/25.
//

import Foundation

struct SortSelectionCellRO {
    let sortType: SortSelectionCellType
    var sortDirection: TickerSortingDirection
    
    // View state
    var displayText: String = "Test"
    var displayImageName: String {
        switch sortDirection {
        case .neutral:
            "chevron.up.chevron.down"
        case .ascending:
            "arrowtriangle.up.fill"
        case .descending:
            "arrowtriangle.down.fill"
        }
    }
    var isLoad: Bool { !displayText.isEmpty }
    
    
    init(sortType: SortSelectionCellType, sortDirection: TickerSortingDirection) {
        self.sortType = sortType
        self.sortDirection = sortDirection
    }
}
