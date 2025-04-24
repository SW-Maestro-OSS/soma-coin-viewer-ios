//
//  SingleMarketTickerRepository.swift
//  Domain
//
//  Created by choijunios on 4/24/25.
//

import DomainInterface
import CoreUtil

public struct StubSingleMarketTickerRepository: SingleMarketTickerRepository {
    
    public init() { }
    
    public func request24hTickerChange(pairSymbol: String) -> AsyncStream<Twenty4HourTickerForSymbolVO> {
        AsyncStream { continuation in
            let vo = Twenty4HourTickerForSymbolVO(
                pairSymbol: "BTCUSDT",
                price: 0.0,
                totalTradedQuoteAssetVolume: 0.0,
                changedPercent: 0.0,
                bestBidPrice: 0.0,
                bestAskPrice: 0.0
            )
            continuation.yield(vo)
        }
    }
}
