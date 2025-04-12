//
//  BinacneOrderbookUpdateDTO+toEntity.swift
//  Repository
//
//  Created by choijunios on 11/1/24.
//

import DomainInterface
import DataSource
import CoreUtil

extension BinacneOrderbookUpdateDTO {
    func toEntity() -> OrderbookUpdateVO {
        let converter = { (info: [String]) -> Orderbook in
            Orderbook(price: CVNumber(Double(info[0])!), quantity: CVNumber(Double(info[1])!))
        }
        return OrderbookUpdateVO(
            bids: bids.map(converter),
            asks: asks.map(converter),
            lastUpdateId: self.finalUpdateId
        )
    }
}
