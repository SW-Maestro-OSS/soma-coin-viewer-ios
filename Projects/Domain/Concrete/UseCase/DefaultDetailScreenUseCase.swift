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
    func getWholeOrderbookTable() async -> OrderbookUpdateVO {
        await orderbookRepository.getWhileTable()
    }
    
    func getChangeInOrderbook() -> AsyncStream<OrderbookUpdateVO> {
        orderbookRepository.getUpdate()
    }
}
