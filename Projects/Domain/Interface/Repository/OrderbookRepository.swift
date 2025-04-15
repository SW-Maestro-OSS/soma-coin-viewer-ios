//
//  OrderbookRepository.swift
//  Domain
//
//  Created by choijunios on 4/12/25.
//

import Combine

public protocol OrderbookRepository {
    func getWholeTable(symbolPair: String) async throws -> OrderbookUpdateVO
    func getUpdate(symbolPair: String) -> AsyncStream<OrderbookUpdateVO>
}
