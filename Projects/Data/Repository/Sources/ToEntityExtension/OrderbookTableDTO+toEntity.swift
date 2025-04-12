//
//  OrderbookTableDTO+toEntity.swift
//  Data
//
//  Created by choijunios on 4/12/25.
//

import DataSource
import DomainInterface
import CoreUtil

extension OrderbookTableDTO {
    func toEntity() -> OrderbookUpdateVO {
        let converter = { (info: [String]) -> Orderbook in
            Orderbook(price: CVNumber(Double(info[0])!), quantity: CVNumber(Double(info[1])!))
        }
        return OrderbookUpdateVO(
            bids: bids.map(converter),
            asks: asks.map(converter),
            lastUpdateId: self.lastUpdateId
        )
    }
}
