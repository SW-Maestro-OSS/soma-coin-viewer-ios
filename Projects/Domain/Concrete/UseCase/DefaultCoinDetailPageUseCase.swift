//
//  DefaultCoinDetailPageUseCase.swift
//  Domain
//
//  Created by choijunios on 4/12/25.
//

import Combine

import DomainInterface
import WebSocketManagementHelper
import CoreUtil

final public class DefaultCoinDetailPageUseCase: CoinDetailPageUseCase {

    @Injected private var orderbookRepository: OrderbookRepository
    @Injected private var singleTickerRepository: SingleMarketTickerRepository
    @Injected private var coinTradeRepository: TradeRepository
    @Injected private var webSocketHelper: WebSocketManagementHelper
    
    public init() { }
}


// MARK: Orderbook
public extension DefaultCoinDetailPageUseCase {
    func connectToOrderbookStream(symbolPair: String) {
        webSocketHelper.requestSubscribeToStream(streams: ["\(symbolPair.lowercased())@depth"])
    }
    
    func connectToTickerChangesStream(symbolPair: String) {
        webSocketHelper.requestSubscribeToStream(streams: ["\(symbolPair.lowercased())@ticker"])
    }
    
    func connectToRecentTradeStream(symbolPair: String) {
        webSocketHelper.requestSubscribeToStream(streams: ["\(symbolPair.lowercased())@trade"])
    }
    
    func disconnectToStreams(symbolPair: String) {
        let symbol = symbolPair.lowercased()
        webSocketHelper.requestUnsubscribeToStream(streams: [
            "\(symbol)@depth",
            "\(symbol)@ticker",
            "\(symbol)@trade",
        ])
    }
    
    func getWholeOrderbookTable(symbolPair: String) async throws -> OrderbookUpdateVO {
        try await orderbookRepository.getWholeTable(symbolPair: symbolPair)
    }
    
    func getChangeInOrderbook(symbolPair: String) -> AsyncStream<OrderbookUpdateVO> {
        orderbookRepository.getUpdate(symbolPair: symbolPair)
    }
    
    func get24hTickerChange(symbolPair: String) -> AsyncStream<Twenty4HourTickerForSymbolVO> {
        singleTickerRepository.request24hTickerChange(pairSymbol: symbolPair)
    }
    
    func getRecentTrade(symbolPair: String) -> AsyncStream<CoinTradeVO> {
        coinTradeRepository.getSingleTrade(symbolPair: symbolPair)
    }
}
