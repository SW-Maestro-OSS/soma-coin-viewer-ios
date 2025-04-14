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
    @Injected private var webSocketHelper: WebSocketManagementHelper
    
    public init() { }
}


// MARK: Orderbook
public extension DefaultCoinDetailPageUseCase {
    func connectToStream(symbolPair: String) {
        webSocketHelper.requestSubscribeToStream(streams: ["\(symbolPair.lowercased())@depth"])
    }
    
    func getWholeOrderbookTable(symbolPair: String) async throws -> OrderbookUpdateVO {
        try await orderbookRepository.getWhileTable(symbolPair: symbolPair)
    }
    
    func getChangeInOrderbook(symbolPair: String) -> AsyncStream<OrderbookUpdateVO> {
        orderbookRepository.getUpdate(symbolPair: symbolPair)
    }
    
    func get24hChanges(symbolPair: String) -> AsyncStream<Twenty4HourTickerForSymbolVO> {
        singleTickerRepository.request24hTicker(pairSymbol: symbolPair)
    }
}
