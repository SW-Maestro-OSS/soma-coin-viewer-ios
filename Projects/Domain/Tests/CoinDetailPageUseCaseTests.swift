//
//  CoinDetailPageUseCaseTests.swift
//  Domain
//
//  Created by choijunios on 4/24/25.
//

import Testing
import Combine

import DomainInterface
import DomainTesting

@testable import Domain

struct CoinDetailPageUseCaseTests {
    @Test("bid, ask오더북 리스트가 올바르게 정렬되어 반환되는지 확인")
    func checkOrdebookTableSortingState() async throws {
        // Given
        let useCase = DefaultCoinDetailPageUseCase(
            orderbookRepository: StubOrderbookRepository(bidOrderbookCount: 50, askOrderbookCount: 50),
            singleTickerRepository: StubSingleMarketTickerRepository(),
            coinTradeRepository: StubCoinTradeRepository(),
            exchangeRateRepository: FakeExchangeRateRepository()
        )
        
        
        // When
        let published_table = useCase.getOrderbookTable(symbolPair: "-", rowCount: 30)
        
        
        // Then
        for try await table in published_table.values {
            // 매수, 내림차순 정렬
            let sorted_bids = table.bidOrderbooks.sorted(by: { $0.price > $1.price })
            #expect(sorted_bids == table.bidOrderbooks)
            
            // 매도, 오름차순 정렬
            let sorted_asks = table.askOrderbooks.sorted(by: { $0.price < $1.price })
            #expect(sorted_asks == table.askOrderbooks)
            break
        }
    }
}
