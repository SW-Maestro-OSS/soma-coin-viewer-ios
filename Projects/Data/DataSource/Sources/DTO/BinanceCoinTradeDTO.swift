//
//  BinanceCoinTradeDTO.swift
//  Data
//
//  Created by choijunios on 4/15/25.
//

public struct BinanceCoinTradeDTO: Decodable {
    public let eventType: String          // "e": "trade"
    public let eventTime: Int64           // "E": 1672515782136
    public let symbol: String             // "s": "BNBBTC"
    public let tradeID: Int               // "t": 12345
    public let price: String              // "p": "0.001"
    public let quantity: String           // "q": "100"
    public let tradeTime: Int64           // "T": 1672515782136
    public let isBuyerMarketMaker: Bool   // "m": true

    enum CodingKeys: String, CodingKey {
        case eventType = "e"
        case eventTime = "E"
        case symbol = "s"
        case tradeID = "t"
        case price = "p"
        case quantity = "q"
        case tradeTime = "T"
        case isBuyerMarketMaker = "m"
    }
}
