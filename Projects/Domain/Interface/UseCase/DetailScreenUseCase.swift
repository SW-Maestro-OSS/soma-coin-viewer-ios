//
//  DetailScreenUseCase.swift
//  Domain
//
//  Created by choijunios on 4/12/25.
//

import Combine

public protocol DetailScreenUseCase {
    
    func getWholeOrderbookTable() async -> OrderbookUpdateVO
    func getChangeInOrderbook() -> AsyncStream<OrderbookUpdateVO>
}
