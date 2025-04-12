//
//  OrderbookRepository.swift
//  Domain
//
//  Created by choijunios on 4/12/25.
//

import Combine

public protocol OrderbookRepository {
    func getWhileTable() async -> OrderbookUpdateVO
    func getUpdate() -> AsyncStream<OrderbookUpdateVO>
}
