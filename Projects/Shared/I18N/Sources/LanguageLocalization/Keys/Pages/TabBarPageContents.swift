//
//  TabBarPageContents.swift
//  I18N
//
//  Created by choijunios on 5/14/25.
//

public enum TabBarPageContents: String, Sendable {
    case tabIconMarketTitle
    case tabIconSettingTitle
    
    var keyPart: String { self.rawValue }
}
