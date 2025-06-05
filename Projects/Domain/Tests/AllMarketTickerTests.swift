//
//  AllMarketTickerTests.swift
//  DomainTests
//
//  Created by choijunios on 11/2/24.
//

import Testing
import Combine

import DomainInterface
import DomainTesting

@testable import Domain

// MARK: AllMarketTickerUseCaseTests
struct AllMarketTickerUseCaseTests {
    
    @Test("티커의 가격에 환율정보가 반영되는지 확인합니다.")
    func exchange_rate_is_applied_to_ticker_price() async {
        /// #1. Arrange
        ///
        /// - Arrange1: 환율은 달러의 2배
        let exchangeRateRepository = StubExchangeRateRepository()
        exchangeRateRepository.set(base: .dollar, to: .won, rate: 2.0)
        /// - Arrange2: 단일 Ticker, 가격은 100달러
        let tickerRepository = StubAllMarketTickerRepository(
            tickers: [
                .init(
                    pairSymbol: "TESTUSDT",
                    price: 100,
                    totalTradedQuoteAssetVolume: 0.0,
                    changedPercent: 0.0,
                    bestBidPrice: 0.0,
                    bestAskPrice: 0.0
                )
            ]
        )
        /// - Arrange3: 원화설정 적용
        let userConfigRepository = FakeUserConfigurationRepository(
            currencyType: .won
        )
        let sut = DefaultAllMarketTickersUseCase(
            allMarketTickersRepository: tickerRepository,
            exchangeRateRepository: exchangeRateRepository,
            userConfigurationRepository: userConfigRepository
        )
        
        
        /// #2. Act
        let list = sut.getTickerListStream()
        
        
        /// #3. Assert
        for await tickerList in list.values {
            /// - 가격에 환율이 반영됬는지 확인
            #expect(tickerList.tickers.first!.price == 200)
            
            break
        }
    }
}
