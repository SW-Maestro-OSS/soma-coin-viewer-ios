//
//  BinanceStreamDecoder.swift
//  WebSocketManagementHelper
//
//  Created by choijunios on 4/22/25.
//

public struct BinanceStreamDecoder: StreamDecoder {
    public init() { }
    public func decode(_ stream: WebSocketStream) -> String {
        switch stream {
        case .allMarketTickerChangesIn24h:
            "!ticker@arr"
        case .orderbook(let symbolPair):
            "\(symbolPair.lowercased())@depth"
        case .tickerChangesIn24h(let symbolPair):
            "\(symbolPair.lowercased())@ticker"
        case .recentTrade(let symbolPair):
            "\(symbolPair.lowercased())@trade"
        }
    }
}
