//
//  AllMarketTickerTests.swift
//  DomainTests
//
//  Created by choijunios on 11/2/24.
//

import Testing
import Foundation
import Combine

@testable import DomainInterface
@testable import Domain
@testable import DomainTesting

import WebSocketManagementHelper
import CoreUtil

// MARK: AllMarketTickerUseCaseTests
struct AllMarketTickerUseCaseTests {
    
    @Test
    func checkSortedArrayIsReturning() async {
        
        // Given
        let usdtTickers = (0..<30).map { index in
            Twenty4HourTickerForSymbolVO(
                pairSymbol: "symbol\(index)USDT",
                price: .init(100.0),
                totalTradedQuoteAssetVolume: .init(100 + index)!,
                changedPercent: .init(50.0),
                bestBidPrice: .init(0.0),
                bestAskPrice: .init(0.0)
            )
        }
        let anonymousTickers = (0..<30).map { index in
            Twenty4HourTickerForSymbolVO(
                pairSymbol: "symbol\(index)CJY",
                price: .init(100.0),
                totalTradedQuoteAssetVolume: .init(100 + index)!,
                changedPercent: .init(50.0),
                bestBidPrice: .init(0.0),
                bestAskPrice: .init(0.0)
            )
        }
        let givenTickers = usdtTickers + anonymousTickers
        DependencyInjector.shared.register(
            AllMarketTickersRepository.self,
            StubAllMarketTickersRepository(stubTickerEntities: givenTickers)
        )
        DependencyInjector.shared.register(
            WebSocketManagementHelper.self,
            StubAllwaysConnectedWebSocketHelper()
        )
        let defaultAllMarketTickersUseCase = DefaultAllMarketTickersUseCase()

        
        // When
        // 티커 요청시
        for await fetchedTickers in defaultAllMarketTickersUseCase.requestTickers().values {
            
            // Then
            
            // #1. 30개가 반홨됬는지 확인합니다.
            #expect(fetchedTickers.count <= 30)
            
            
            // #2. 30개의 티커 객체가 USDT를 포함하는 지 확인합니다.
            fetchedTickers.forEach { ticker in
                #expect(ticker.secondSymbol == "USDT")
            }
            
            
            // #3. totalTradedQuoteAssetVolume을 기준으로 올바르게 정렬됬는지 확인합니다.
            let expectedTickers = fetchedTickers.sorted {
                $0.totalTradedQuoteAssetVolume > $1.totalTradedQuoteAssetVolume
            }
            for index in 0..<fetchedTickers.count {
                #expect(
                    expectedTickers[index].totalTradedQuoteAssetVolume ==
                    fetchedTickers[index].totalTradedQuoteAssetVolume
                )
            }
            
        }
    }
}
