//
//  BinanceAllMarketTickersRepository.swift
//  Repository
//
//  Created by choijunios on 11/1/24.
//

import Foundation
import Combine

import DataSource
import DomainInterface
import CoreUtil

public class BinanceAllMarketTickersRepository: AllMarketTickersRepository {
    // Dependency
    @Injected var webSocketService: WebSocketService
    
    public init() { }
    
    public func request24hTickerForAllSymbols() -> AnyPublisher<[Twenty4HourTickerForSymbolVO], Never> {
                
        webSocketService
            .getMessageStream()
            .map { (dto: [BinanceTickerForSymbolDTO]) in
                let entities = dto.map { $0.toEntity() }
                return entities
            }
            .eraseToAnyPublisher()
    }
}
