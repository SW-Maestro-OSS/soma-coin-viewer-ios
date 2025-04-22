//
//  WebSocketStream.swift
//  WebSocketManagementHelper
//
//  Created by choijunios on 4/22/25.
//

public enum WebSocketStream {
    // AllMarketTicker
    case allMarketTickerChangesIn24h
    
    // CoinDetailPage
    case orderbook(symbolPair: String)
    case tickerChangesIn24h(symbolPair: String)
    case recentTraße(symbolPair: String)
}
