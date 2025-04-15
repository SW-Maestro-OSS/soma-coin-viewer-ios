//
//  TradeRepository.swift
//  Domain
//
//  Created by choijunios on 4/15/25.
//

public protocol TradeRepository {
    func getSingleTrade(pairSymbol: String) -> AsyncStream<CoinTradeVO>
}
