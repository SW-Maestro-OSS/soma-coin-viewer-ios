//
//  OrderbookTableDTO+toEntity.swift
//  Data
//
//  Created by choijunios on 4/12/25.
//

import DataSource
import DomainInterface

extension OrderbookTableDTO {
    func toEntity() -> OrderbookUpdateVO {
        let converter = { (info: [String]) -> OrderbookUpdateVO.Order in
            OrderbookUpdateVO.Order(price: Double(info[0])!, quantity: Double(info[1])!)
        }
        return OrderbookUpdateVO(
            bids: bids.map(converter),
            asks: asks.map(converter),
            lastUpdateId: self.lastUpdateId
        )
    }
}
