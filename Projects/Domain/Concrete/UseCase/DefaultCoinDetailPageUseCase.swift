//
//  DefaultCoinDetailPageUseCase.swift
//  Domain
//
//  Created by choijunios on 4/12/25.
//

import Combine

import DomainInterface
import CoreUtil

final public class DefaultCoinDetailPageUseCase: CoinDetailPageUseCase {
    // Dependency
    @Injected private var orderbookRepository: OrderbookRepository
    @Injected private var singleTickerRepository: SingleMarketTickerRepository
    @Injected private var coinTradeRepository: CoinTradeRepository
    
    public init() { }
}


// MARK: CoinDetailPageUseCase
public extension DefaultCoinDetailPageUseCase {
    func get24hTickerChange(symbolPair: String) -> AsyncStream<Twenty4HourTickerForSymbolVO> {
        singleTickerRepository.request24hTickerChange(pairSymbol: symbolPair)
    }
    
    func getRecentTrade(symbolPair: String, maxRowCount: UInt) -> AnyPublisher<[CoinTradeVO], Never> {
        coinTradeRepository
            .getCoinTradeList(symbolPair: symbolPair, tableUpdateInterval: 0.5)
            .map { entity in
                // 최신으로 maxRowCount개수 만큼
                let slicedList = entity
                    .keys(order: .DESC, maxCount: maxRowCount)
                    .compactMap { key in entity[key] }
                    .prefix(Int(maxRowCount))
                return Array(slicedList)
            }
            .eraseToAnyPublisher()
    }
    
    func getOrderbookTable(symbolPair: String, rowCount: UInt) -> AnyPublisher<OrderbookTableVO, Error> {
        orderbookRepository
            .getOrderbookTable(symbolPair: symbolPair)
            .map { orderbookTable in
                let bidOrderbookList = orderbookTable.bidOrderbooks
                    .keys(order: .DESC, maxCount: rowCount)
                    .map { Orderbook(price: $0, quantity: orderbookTable.bidOrderbooks[$0]!) }
                let askOrderbookList = orderbookTable.askOrderbooks
                    .keys(order: .ASC, maxCount: rowCount)
                    .map { Orderbook(price: $0, quantity: orderbookTable.askOrderbooks[$0]!) }
                return OrderbookTableVO(
                    bidOrderbooks: bidOrderbookList,
                    askOrderbooks: askOrderbookList
                )
            }
            .eraseToAnyPublisher()
    }
}
