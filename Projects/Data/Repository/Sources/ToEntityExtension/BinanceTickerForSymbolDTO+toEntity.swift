//
//  BinanceTickerForSymbolDTO+toEntity.swift
//  Repository
//
//  Created by choijunios on 11/1/24.
//

import Foundation

import DataSource
import DomainInterface

// MARK: Binance API

extension BinanceTickerForSymbolDTO {
    
    func toEntity() -> Twenty4HourTickerForSymbolVO {
        
        return .init(
            symbol: symbol,
            price: Double(lastPrice) ?? 0.0,
            totalTradedQuoteAssetVolume: Double(quoteAssetVolume) ?? 0.0,
            changedPercent: Double(priceChangePercent) ?? 0.0
        )
    }
}
