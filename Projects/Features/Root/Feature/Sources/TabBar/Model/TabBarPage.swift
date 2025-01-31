//
//  TabBarPage.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

enum TabBarPage: String, Identifiable, CaseIterable {
    
    var id: String { self.rawValue }
    
    case allMarketTicker
    case setting
    
    var systemIconName: String {
        switch self {
        case .allMarketTicker:
            "24.square"
        case .setting:
            "gear"
        }
    }
    
    var titleTextLocalizationKey: String {
        switch self {
        case .allMarketTicker:
            "AllMarketTickerPage_tabBar_market"
        case .setting:
            "AllMarketTickerPage_tabBar_setting"
        }
    }
}
