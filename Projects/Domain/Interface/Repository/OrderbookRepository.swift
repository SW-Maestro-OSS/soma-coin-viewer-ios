//
//  OrderbookRepository.swift
//  Domain
//
//  Created by choijunios on 4/12/25.
//

import Combine

public protocol OrderbookRepository {
    func getOrderbookTable(symbolPair: String) -> AnyPublisher<OrderbookTable, Error>
}
