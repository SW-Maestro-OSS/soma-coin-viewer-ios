//
//  CoinDetailPageUseCase.swift
//  Domain
//
//  Created by choijunios on 4/12/25.
//

import Combine

public protocol CoinDetailPageUseCase {
    func connectToOrderbookStream(symbolPair: String)
    func connectToTickerChangesStream(symbolPair: String)
    func connectToRecentTradeStream(symbolPair: String)
    func disconnectToStreams(symbolPair: String)
    
    func getOrderbookTable(symbolPair: String, rowCount: UInt) -> AnyPublisher<OrderbookTableVO, Error>
    func get24hTickerChange(symbolPair: String) -> AsyncStream<Twenty4HourTickerForSymbolVO>
    func getRecentTrade(symbolPair: String) -> AsyncStream<CoinTradeVO>
    func getRecentTrade(symbolPair: String, maxRowCount: UInt) -> AnyPublisher<[CoinTradeVO], Never>
}
