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
    
    @Test("Suffix심볼이 USDT인지 확인")
    func checkSuffixSymbolIsUSDT() async {
        // Given
        let useCase = DefaultAllMarketTickersUseCase(
            allMarketTickersRepository: StubAllMarketTickerRepository(maxTickerCount: 10000, usdtSuffixCount: 2500),
            exchangeRateRepository: StubExchangeRateRepository(fixedRate: 1.0),
            userConfigurationRepository: StubUserConfigurationRepository()
        )
        
        
        // When
        let published_tickers: AnyPublisher<[Twenty4HourTickerForSymbolVO], Never> = useCase.getTickerList(rowCount: 2500)
        let async_tickers = await useCase.getTickerList(rowCount: 2500)
        
        
        // Then
        for await tickers in published_tickers.values {
            for ticker in tickers {
                #expect(ticker.secondSymbol.uppercased() == "USDT")
            }
            break
        }
        for ticker in async_tickers {
            #expect(ticker.secondSymbol.uppercased() == "USDT")
        }
    }
    
    @Test("totalTradedQuoteAssetVolume이 큰 기준으로 정해진 개수를 추출하는지 확인")
    func checkFetchingCollectList() async {
        // Given
        let useCase = DefaultAllMarketTickersUseCase(
            allMarketTickersRepository: StubAllMarketTickerRepository(maxTickerCount: 10000, usdtSuffixCount: 2500),
            exchangeRateRepository: StubExchangeRateRepository(fixedRate: 1.0),
            userConfigurationRepository: StubUserConfigurationRepository()
        )
        
        
        // When
        let published_tickers: AnyPublisher<[Twenty4HourTickerForSymbolVO], Never> = useCase.getTickerList(rowCount: 2500)
        let async_tickers = await useCase.getTickerList(rowCount: 2500)
        
        
        // Then
        for await tickers in published_tickers.values {
            #expect(tickers.count == 2500)
            let sorted = tickers.sorted(by: { $0.totalTradedQuoteAssetVolume > $1.totalTradedQuoteAssetVolume })
            #expect(sorted == tickers)
            break
        }
        #expect(async_tickers.count == 2500)
        let sorted = async_tickers.sorted(by: { $0.totalTradedQuoteAssetVolume > $1.totalTradedQuoteAssetVolume })
        #expect(sorted == async_tickers)
    }
}
