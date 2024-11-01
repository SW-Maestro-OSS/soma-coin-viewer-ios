//
//  SymbolTickerDTO.swift
//  Repository
//
//  Created by choijunios on 11/1/24.
//

import Foundation

public struct SymbolTickerDTO: Codable {
    
    public let eventType: String
    public let eventTime: Int
    public let symbol: String
    public let priceChange: String
    public let priceChangePercent: String
    public let weightedAveragePrice: String
    public let firstTradePrice: String
    public let lastPrice: String
    public let lastQuantity: String
    public let bestBidPrice: String
    public let bestBidQuantity: String
    public let bestAskPrice: String
    public let bestAskQuantity: String
    public let openPrice: String
    public let highPrice: String
    public let lowPrice: String
    public let baseAssetVolume: String
    public let quoteAssetVolume: String
    public let openTime: Int
    public let closeTime: Int
    public let firstTradeID: Int
    public let lastTradeID: Int
    public let totalTrades: Int
    
    enum CodingKeys: String, CodingKey {
        case eventType = "e"
        case eventTime = "E"
        case symbol = "s"
        case priceChange = "p"
        case priceChangePercent = "P"
        case weightedAveragePrice = "w"
        case firstTradePrice = "x"
        case lastPrice = "c"
        case lastQuantity = "Q"
        case bestBidPrice = "b"
        case bestBidQuantity = "B"
        case bestAskPrice = "a"
        case bestAskQuantity = "A"
        case openPrice = "o"
        case highPrice = "h"
        case lowPrice = "l"
        case baseAssetVolume = "v"
        case quoteAssetVolume = "q"
        case openTime = "O"
        case closeTime = "C"
        case firstTradeID = "F"
        case lastTradeID = "L"
        case totalTrades = "n"
    }
}
