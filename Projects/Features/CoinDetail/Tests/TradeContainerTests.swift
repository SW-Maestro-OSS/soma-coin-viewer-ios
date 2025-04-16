//
//  TradeContainerTests.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/17/25.
//

import Testing

@testable import CoinDetailFeature

struct TradeContainerRuntimeErrorTest {
    @Test("단기간 동시 접근시 런타임 에러 확인")
    func shortTermConcurrency() async {
        // Given
        let container = TradeContainer(maxCount: 1000)
        
        // When
        for index in 0..<1000 {
            Task.detached {
                try await Task.sleep(for: .seconds(1))
                await container.insert(element: .init(
                    tradeId: String(index),
                    tradeType: .buy,
                    price: .init(0.0),
                    quantity: .init(0.0),
                    tradeTime: .now
                ))
            }
            Task.detached {
                try await Task.sleep(for: .seconds(0.5))
                _ = await container.getList()
            }
        }
        try? await Task.sleep(for: .seconds(10))
        
        // Then
        #expect(await container.getList().count == 1000)
    }
}
