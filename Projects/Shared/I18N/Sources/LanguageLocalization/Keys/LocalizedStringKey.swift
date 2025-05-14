//
//  LocalizedStringKey.swift
//  I18N
//
//  Created by choijunios on 5/14/25.
//

public enum LocalizedStringKey {
    case pageKey(page: Page)
    
    var key: String {
        switch self {
        case .pageKey(let page):
            "page_\(page.keyPart)"
        }
    }
}


// MARK: Native types
extension LocalizedStringKey {
    public enum Page {
        case allMarketTicker(contents: AllMarketTickerPageContents)
        
        var keyPart: String {
            switch self {
            case .allMarketTicker(let contents):
                "allMarketTicker_\(contents.keyPart)"
            }
        }
    }
}
