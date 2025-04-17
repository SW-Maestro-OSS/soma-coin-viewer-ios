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
    
    func getWholeOrderbookTable(symbolPair: String) async throws -> OrderbookUpdateVO
    func getChangeInOrderbook(symbolPair: String) -> AsyncStream<OrderbookUpdateVO>
    func get24hTickerChange(symbolPair: String) -> AsyncStream<Twenty4HourTickerForSymbolVO>
    func getRecentTrade(symbolPair: String) -> AsyncStream<CoinTradeVO>
}
