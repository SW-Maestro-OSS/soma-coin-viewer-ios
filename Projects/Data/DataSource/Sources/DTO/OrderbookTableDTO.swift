//
//  OrderbookTableDTO.swift
//  Data
//
//  Created by choijunios on 4/12/25.
//

public struct OrderbookTableDTO: Decodable {
    public let lastUpdateId: Int
    public let bids: [[String]]
    public let asks: [[String]]
}
