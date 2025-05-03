//
//  BinanceSingleMarketTickerRepository.swift
//  Data
//
//  Created by choijunios on 4/14/25.
//

import DomainInterface
import DataSource
import CoreUtil

final public class BinanceSingleMarketTickerRepository: SingleMarketTickerRepository {
    // Dependency
    @Injected private var webSocketService: WebSocketService
    
    public init() { }
    
    public func request24hTickerChange(pairSymbol: String) -> AsyncStream<DomainInterface.Twenty4HourTickerForSymbolVO> {
        let publisher = webSocketService
            .getMessageStream()
            .filter { (dto: BinanceTickerForSymbolDTO) in
                dto.symbol.lowercased() == pairSymbol.lowercased()
            }
            .map({ $0.toEntity() })
            return AsyncStream { continuation in
                let cancellable = publisher
                    .sink(receiveValue: { entity in
                        continuation.yield(entity)
                    })
                continuation.onTermination = { @Sendable [cancellable] _ in
                    cancellable.cancel()
                }
            }
    }
}
