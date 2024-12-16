//
//  TabBarPage.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

enum TabBarPage: Identifiable, CaseIterable {
    
    var id: Int { self.pageOrder }
    
    case allMarketTicker
    case setting
    
    var pageOrder: Int {
        
        switch self {
        case .allMarketTicker:
            return 0
        case .setting:
            return 1
        }
    }
    
    static var orderedPages: [Self] {
        Self.allCases.sorted {
            $0.pageOrder < $1.pageOrder
        }
    }
}
