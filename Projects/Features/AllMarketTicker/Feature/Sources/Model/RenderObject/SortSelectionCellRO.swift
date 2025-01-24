//
//  SortSelectionCellRO.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/23/25.
//

import Foundation

enum SortSelectionCellState {
    case neutral
    case ascending
    case descending
}

struct SortSelectionCellRO: Identifiable {
    
    var id: SortSelectionCellType { type }
    
    let type: SortSelectionCellType
    var sortState: SortSelectionCellState
    
    // View state
    var displayText: String = "Test"
    var displayImageName: String {
        switch sortState {
        case .neutral:
            "chevron.up.chevron.down"
        case .ascending:
            "arrowtriangle.up.fill"
        case .descending:
            "arrowtriangle.down.fill"
        }
    }
    var isLoad: Bool { !displayText.isEmpty }
    
    
    init(type: SortSelectionCellType, sortState: SortSelectionCellState) {
        self.type = type
        self.sortState = sortState
    }
}
