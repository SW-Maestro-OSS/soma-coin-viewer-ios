//
//  BinacneOrderbookUpdateDTO.swift
//  Data
//
//  Created by choijunios on 4/12/25.
//

public struct BinacneOrderbookUpdateDTO: Decodable {
    public let eventType: String       // "e"
    public let eventTime: Int          // "E"
    public let symbol: String          // "s"
    public let firstUpdateId: Int      // "U"
    public let finalUpdateId: Int      // "u"
    public let bids: [[String]]        // "b" - [price, quantity]
    public let asks: [[String]]        // "a" - [price, quantity]

    enum CodingKeys: String, CodingKey {
        case eventType = "e"
        case eventTime = "E"
        case symbol = "s"
        case firstUpdateId = "U"
        case finalUpdateId = "u"
        case bids = "b"
        case asks = "a"
    }
}
