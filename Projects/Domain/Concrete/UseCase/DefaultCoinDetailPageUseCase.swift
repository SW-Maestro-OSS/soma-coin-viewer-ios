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
    // Dependency
    @Injected private var orderbookRepository: OrderbookRepository
    @Injected private var singleTickerRepository: SingleMarketTickerRepository
    @Injected private var coinTradeRepository: TradeRepository
    @Injected private var webSocketHelper: WebSocketManagementHelper
    
    public init() { }
}


// MARK: CoinDetailPageUseCase
public extension DefaultCoinDetailPageUseCase {
    func connectToOrderbookStream(symbolPair: String) {
        webSocketHelper.requestSubscribeToStream(streams: ["\(symbolPair.lowercased())@depth"], mustDeliver: true)
    }
    
    func connectToTickerChangesStream(symbolPair: String) {
        webSocketHelper.requestSubscribeToStream(streams: ["\(symbolPair.lowercased())@ticker"], mustDeliver: true)
    }
    
    func connectToRecentTradeStream(symbolPair: String) {
        webSocketHelper.requestSubscribeToStream(streams: ["\(symbolPair.lowercased())@trade"], mustDeliver: true)
    }
    
    func disconnectToStreams(symbolPair: String) {
        let symbol = symbolPair.lowercased()
        webSocketHelper.requestUnsubscribeToStream(streams: [
            "\(symbol)@depth",
            "\(symbol)@ticker",
            "\(symbol)@trade",
        ], mustDeliver: false)
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
    
    func getOrderbookTable(symbolPair: String, rowCount: UInt) -> AnyPublisher<OrderbookTableVO2, Error> {
        orderbookRepository
            .getOrderbookTable(symbolPair: symbolPair)
            .map { orderbookTable in
                let bidOrderbookList = orderbookTable.bidOrderbooks
                    .keys(order: .DESC, maxCount: rowCount)
                    .map { Orderbook(price: $0, quantity: orderbookTable.bidOrderbooks[$0]!) }
                let askOrderbookList = orderbookTable.askOrderbooks
                    .keys(order: .ASC, maxCount: rowCount)
                    .map { Orderbook(price: $0, quantity: orderbookTable.bidOrderbooks[$0]!) }
                return OrderbookTableVO2(
                    askOrderbooks: bidOrderbookList,
                    bidOrderbooks: askOrderbookList
                )
            }
            .eraseToAnyPublisher()
    }
}
