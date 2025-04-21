//
//  BinanceTradeRepository.swift
//  Data
//
//  Created by choijunios on 4/15/25.
//

import Foundation
import Combine

import DomainInterface
import DataSource
import CoreUtil

public final class BinanceCoinTradeRepository: CoinTradeRepository {
    // Dependency
    @Injected private var webSocketService: WebSocketService
    @Injected private var coinTradeDataSource: CoinTradeDataSource
    
    public init() { }
    
    public func getCoinTradeList(symbolPair: String) -> AnyPublisher<HashMap<Date, CoinTradeVO>, Never> {
        coinTradeDataSource
            .getTradeList(symbolPair: symbolPair)
            .map { dtoList in
                var entityList = HashMap<Date, CoinTradeVO>()
                dtoList.values.forEach { dto in
                    let entity = dto.toEntity()
                    entityList[entity.tradeTime] = entity
                }
                return entityList
            }
            .eraseToAnyPublisher()
    }
    
    public func getSingleTrade(symbolPair: String) -> AsyncStream<CoinTradeVO> {
        let publisher = webSocketService
            .getMessageStream()
            .filter({ (dto: BinanceCoinTradeDTO) in
                dto.symbol.lowercased() == symbolPair.lowercased()
            })
            .map({ $0.toEntity() })
            return AsyncStream { continuation in
                let cancellable = publisher
                    .sink(receiveValue: { entity in
                        continuation.yield(entity)
                    })
                continuation.onTermination = { @Sendable _ in
                    cancellable.cancel()
                }
            }
    }
}
