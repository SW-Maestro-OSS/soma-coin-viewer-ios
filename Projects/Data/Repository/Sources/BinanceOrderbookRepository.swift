//
//  BinanceOrderbookRepository.swift
//  Data
//
//  Created by choijunios on 4/12/25.
//

import Foundation

import DomainInterface
import DataSource

final class BinanceOrderbookRepository: OrderbookRepository {
    
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
        let dto = try await httpService.request(requestBuiler, dtoType: OrderbookTableDTO.self, retry: 1)
        return dto.body!.toEntity()
    }
    
    func getUpdate(symbolPair: String) -> AsyncStream<DomainInterface.OrderbookUpdateVO> {
        AsyncStream { continuation in }
    }
}
