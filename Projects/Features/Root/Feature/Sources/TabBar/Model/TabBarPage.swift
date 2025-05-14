//
//  TabBarPage.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

enum TabBarPage: String, Identifiable, CaseIterable {
    var id: String { self.rawValue }
    case market
    case setting
    
    var systemIconName: String {
        switch self {
        case .market:
            "24.square"
        case .setting:
            "gear"
        }
    }
}
