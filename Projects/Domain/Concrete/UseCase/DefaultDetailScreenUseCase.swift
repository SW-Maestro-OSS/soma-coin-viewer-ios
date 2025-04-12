//
//  DefaultDetailScreenUseCase.swift
//  Domain
//
//  Created by choijunios on 4/12/25.
//

import Combine

import DomainInterface

final public class DefaultDetailScreenUseCase: DetailScreenUseCase {

    private let orderbookRepository: OrderbookRepository
    
    init(orderbookRepository: OrderbookRepository) {
        self.orderbookRepository = orderbookRepository
    }
}


// MARK: Orderbook
public extension DefaultDetailScreenUseCase {
    func getWholeOrderbookTable(symbolPair: String) async throws -> OrderbookUpdateVO {
        try await orderbookRepository.getWhileTable(symbolPair: symbolPair)
    }
    
    func getChangeInOrderbook(symbolPair: String) -> AsyncStream<OrderbookUpdateVO> {
        orderbookRepository.getUpdate(symbolPair: symbolPair)
    }
}
