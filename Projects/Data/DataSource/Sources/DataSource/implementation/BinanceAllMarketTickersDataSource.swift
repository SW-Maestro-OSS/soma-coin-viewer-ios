//
//  BinanceAllMarketTickersDataSource.swift
//  Data
//
//  Created by choijunios on 4/22/25.
//

import Combine

import CoreUtil

public final class BinanceAllMarketTickersDataSource: AllMarketTickersDataSource {
    // Dependency
    @Injected private var webSocketService: WebSocketService
    
    // State
    private let store: ThreadSafeDictionary<String, BinanceTickerForSymbolDTO> = .init()
    
    public init() { }
    
    public func getAllMarketTickerList() -> AnyPublisher<[BinanceTickerForSymbolDTO], Never> {
        webSocketService
            .getMessageStream()
            .map { (dto: [BinanceTickerForSymbolDTO]) in dto }
            .unretained(self)
            .asyncTransform { source, dto in
                for tickerDTO in dto {
                    await source.store.insert(key: tickerDTO.symbol, value: tickerDTO)
                }
                return await source.store.values
            }
            .eraseToAnyPublisher()
    }
    
    public func getAllMarketTickerList() async -> [BinanceTickerForSymbolDTO] {
        await store.values
    }
}
