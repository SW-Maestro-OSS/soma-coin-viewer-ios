//
//  BinanceCoinTradeDataSource.swift
//  Data
//
//  Created by choijunios on 4/21/25.
//

import Combine

import Foundation
import CoreUtil

public final class BinanceCoinTradeDataSource: CoinTradeDataSource {
    // Dependency
    @Injected private var webSocketService: WebSocketService
    
    // State
    private let tradeList: ThreadSafeHashMap<Int64, BinanceCoinTradeDTO> = .init()
    
    public init() { }
    
    public func getTradeList(symbolPair: String, tableUpdateInterval: Double?) -> AnyPublisher<HashMap<Int64, BinanceCoinTradeDTO>, Never>  {
        webSocketService
            .getMessageStream()
            .filter { (dto: BinanceCoinTradeDTO) in
                dto.symbol.lowercased() == symbolPair.lowercased()
            }
            .throttle(for: .init(floatLiteral: tableUpdateInterval ?? 0.0), scheduler: DispatchQueue.global(qos: .default), latest: true)
            .unretained(self)
            .asyncTransform { source, dto in
                await source.tradeList.insert(key: dto.tradeTime, value: dto)
                return await source.tradeList.hashMap.copy()
            }
    }
}
