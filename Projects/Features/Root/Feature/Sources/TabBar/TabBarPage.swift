//
//  TabBarPage.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

enum TabBarPage: Int, CaseIterable {
    
    case allMarketTicker = 0
    case setting = 1
    
    var pageOrder: Int { self.rawValue }
}
