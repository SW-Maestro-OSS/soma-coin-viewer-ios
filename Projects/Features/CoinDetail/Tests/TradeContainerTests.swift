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
        var tasks: [Task<Void, Never>] = []
        for index in 0..<1000 {
            let insertTask = Task<Void, Never>.detached {
                try? await Task.sleep(for: .seconds(1))
                await container.insert(element: .init(
                    tradeId: String(index),
                    tradeType: .buy,
                    price: .init(0.0),
                    quantity: .init(0.0),
                    tradeTime: .now
                ))
            }
            tasks.append(insertTask)
            
            let getTask = Task<Void, Never>.detached {
                try? await Task.sleep(for: .seconds(0.5))
                _ = await container.getList()
            }
            tasks.append(getTask)
        }
        
        // Then
        for task in tasks {
            _ = await task.value
        }
        #expect(await container.getList().count == 1000)
    }
}
