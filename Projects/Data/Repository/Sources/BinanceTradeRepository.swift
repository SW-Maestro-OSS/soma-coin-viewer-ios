//
//  BinanceTradeRepository.swift
//  Data
//
//  Created by choijunios on 4/15/25.
//

import DomainInterface
import DataSource
import CoreUtil

final public class BinanceTradeRepository: TradeRepository {
    // Dependency
    @Injected private var webSocketService: WebSocketService
    
    public init() { }
    
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
