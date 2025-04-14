//
//  SingleMarketTickerRepository.swift
//  Domain
//
//  Created by choijunios on 4/14/25.
//

public protocol SingleMarketTickerRepository {
    func request24hTicker(pairSymbol: String) -> AsyncStream<Twenty4HourTickerForSymbolVO>
}
