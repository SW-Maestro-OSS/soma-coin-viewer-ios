//
//  BinanceTickerForSymbolDTO+toEntity.swift
//  Repository
//
//  Created by choijunios on 11/1/24.
//

import Foundation

import DataSource
import DomainInterface
import CoreUtil

// MARK: Binance API

extension BinanceTickerForSymbolDTO {
    func toEntity() -> Twenty4HourTickerForSymbolVO {
        .init(
            pairSymbol: symbol,
            price: CVNumber(Decimal(string: lastPrice) ?? 0.0),
            totalTradedQuoteAssetVolume: CVNumber(Decimal(string: quoteAssetVolume) ?? 0.0),
            changedPercent: CVNumber(Double(priceChangePercent) ?? 0.0),
            bestBidPrice: CVNumber(Decimal(string: bestBidPrice) ?? 0.0),
            bestAskPrice: CVNumber(Decimal(string: bestAskPrice) ?? 0.0)
        )
    }
}
