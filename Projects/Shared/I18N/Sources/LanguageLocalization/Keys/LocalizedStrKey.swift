//
//  LocalizedStringKey.swift
//  I18N
//
//  Created by choijunios on 5/14/25.
//

public enum LocalizedStrKey {
    case pageKey(page: Page)
    
    var key: String {
        switch self {
        case .pageKey(let page):
            "page_\(page.keyPart)"
        }
    }
}


// MARK: Native types
extension LocalizedStrKey {
    public enum Page {
        case tabBar(contents: TabBarPageContents)
        case allMarketTicker(contents: AllMarketTickerPageContents)
        case coinDetail(contents: CoinDetailPageContents)
        case setting(contents: SettingPageContents)
        
        
        var keyPart: String {
            switch self {
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
