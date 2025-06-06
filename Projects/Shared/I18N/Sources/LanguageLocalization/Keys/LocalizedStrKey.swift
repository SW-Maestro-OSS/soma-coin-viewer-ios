//
//  LocalizedStringKey.swift
//  I18N
//
//  Created by choijunios on 5/14/25.
//

public enum LocalizedStrKey: Sendable {
    case pageKey(page: Page)
    case alertKey(contents: AlertContents)
    
    var key: String {
        switch self {
        case .pageKey(let page):
            "page_\(page.keyPart)"
        case .alertKey(let contents):
            "alert_\(contents.keyPart)"
        }
    }
}


// MARK: Native types
public extension LocalizedStrKey {
    enum Page: Sendable {
        case splash(contents: SplashPageContents)
        case tabBar(contents: TabBarPageContents)
        case allMarketTicker(contents: AllMarketTickerPageContents)
        case coinDetail(contents: CoinDetailPageContents)
        case setting(contents: SettingPageContents)
        
        
        var keyPart: String {
            switch self {
            case .splash(let contents):
                "splash_\(contents.keyPart)"
            case .allMarketTicker(let contents):
                "allMarketTicker_\(contents.keyPart)"
            case .tabBar(let contents):
                "tabBar_\(contents.keyPart)"
            case .coinDetail(let contents):
                "coinDetail_\(contents.keyPart)"
            case .setting(let contents):
                "setting_\(contents.keyPart)"
            }
        }
    }
}
