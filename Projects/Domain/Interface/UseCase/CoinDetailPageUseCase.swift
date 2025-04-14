//
//  CoinDetailPageUseCase.swift
//  Domain
//
//  Created by choijunios on 4/12/25.
//

import Combine

public protocol CoinDetailPageUseCase {
    func connectToStream(symbolPair: String)
    func getWholeOrderbookTable(symbolPair: String) async throws -> OrderbookUpdateVO
    func getChangeInOrderbook(symbolPair: String) -> AsyncStream<OrderbookUpdateVO>
}
