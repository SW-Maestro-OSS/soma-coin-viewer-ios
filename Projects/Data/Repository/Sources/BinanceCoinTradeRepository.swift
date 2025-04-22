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
    
    public func getCoinTradeList(symbolPair: String, tableUpdateInterval: Double?) -> AnyPublisher<HashMap<Date, CoinTradeVO>, Never> {
        coinTradeDataSource
            .getTradeList(symbolPair: symbolPair, tableUpdateInterval: tableUpdateInterval)
            .map { dtoList in
                let entityList = HashMap<Date, CoinTradeVO>()
                dtoList.values.forEach { dto in
                    let entity = dto.toEntity()
                    entityList[entity.tradeTime] = entity
                }
                return entityList
            }
            .eraseToAnyPublisher()
    }
}
