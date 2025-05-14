//
//  CoinDetailPageContents.swift
//  I18N
//
//  Created by choijunios on 5/14/25.
//

public enum CoinDetailPageContents: String, Sendable {
    case tickerTableCurrentPriceColumnTitle
    case tickerTableBestBidPriceColumnTitle
    case tickerTableBestAskPriceColumnTitle
    case defaultTableQtyColumnTitle
    case defaultTablePriceColumnTitle
    case defaultTableTradeTimeColumnTitle
    
    var keyPart: String { self.rawValue }
}
