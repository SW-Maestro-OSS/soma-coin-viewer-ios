//
//  BinanceOrderbookRepository.swift
//  Data
//
//  Created by choijunios on 4/12/25.
//

import Foundation

import DomainInterface
import DataSource
import CoreUtil

final class BinanceOrderbookRepository: OrderbookRepository {
    // Dependency
    @Injected var webSocketService: WebSocketService
    private let httpService: HTTPService = .init()
    
    public init() { }
    
    func getWhileTable(symbolPair: String) async throws -> OrderbookUpdateVO {
        let requestBuiler = URLRequestBuilder(
            base: .init(string: "https://api.binance.com/api/v3")!,
            httpMethod: .get
        )
        .add(path: "depth")
        .add(queryParam: [
            "symbol": symbolPair,
            "limit": "5000"
        ])
        let dto = try await httpService.request(requestBuiler, dtoType: BinanceOrderbookTableDTO.self, retry: 1)
        return dto.body!.toEntity()
    }
    
    func getUpdate(symbolPair: String) -> AsyncStream<DomainInterface.OrderbookUpdateVO> {
        let publisher = webSocketService
            .getMessageStream()
            .map { (dto: BinacneOrderbookUpdateDTO) in
                let entity = dto.toEntity()
                return entity
            }
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
