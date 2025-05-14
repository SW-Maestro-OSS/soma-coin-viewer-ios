//
//  AllMarketTickerPageContents.swift
//  I18N
//
//  Created by choijunios on 5/14/25.
//

public enum AllMarketTickerPageContents: String, Sendable {
    case tableSymbolColumnTitle
    case tablePriceColumnTitle
    case table24hchangeColumnTitle
    
    var keyPart: String { self.rawValue }
}
