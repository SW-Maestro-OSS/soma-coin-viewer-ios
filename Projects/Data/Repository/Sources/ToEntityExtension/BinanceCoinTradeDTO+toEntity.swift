//
//  BinanceCoinTradeDTO+toEntity.swift
//  Data
//
//  Created by choijunios on 4/15/25.
//

import Foundation

import DomainInterface
import DataSource
import CoreUtil

extension BinanceCoinTradeDTO {
    func toEntity() -> CoinTradeVO {
        .init(
            tradeId: String(tradeID),
            tradeType: isBuyerMarketMaker ? .sell : .buy,
            price: CVNumber(Decimal(string: self.price)!),
            quantity: CVNumber(Decimal(string: self.quantity)!),
            tradeTime: Date(timeIntervalSince1970: TimeInterval(eventTime) / 1000)
        )
    }
}
