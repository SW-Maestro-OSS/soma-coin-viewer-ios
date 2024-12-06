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
        
        return .init(
            pairSymbol: symbol,
            price: CVNumber(Double(lastPrice) ?? 0.0),
            totalTradedQuoteAssetVolume: CVNumber(Double(quoteAssetVolume) ?? 0.0),
            changedPercent: CVNumber(Double(priceChangePercent) ?? 0.0)
        )
    }
}
