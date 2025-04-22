//
//  CoinDetailPageUseCase.swift
//  Domain
//
//  Created by choijunios on 4/12/25.
//

import Combine

public protocol CoinDetailPageUseCase {
    func getOrderbookTable(symbolPair: String, rowCount: UInt) -> AnyPublisher<OrderbookTableVO, Error>
    func getRecentTrade(symbolPair: String, maxRowCount: UInt) -> AnyPublisher<[CoinTradeVO], Never>
    func get24hTickerChange(symbolPair: String) -> AsyncStream<Twenty4HourTickerForSymbolVO>
}
