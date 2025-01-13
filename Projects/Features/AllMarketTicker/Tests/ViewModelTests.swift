//
//  Tests.swift
//
//

import Testing

@testable import AllMarketTickerFeatureTesting
@testable import AllMarketTickerFeature

import DomainInterface
import CoreUtil

/// 테스트 제목: AllmarketTicker의 선택된 정렬 기준이 올바르게 적용되는지 확인
@Test
func sortingTest() {
    
    // Given
    let viewModel = AllMarketTickerViewModel(
        socketHelper: FakeWebSocketHelper(),
        useCase: FakeAllMarketTickersUseCase(),
        userConfigurationRepository: StubUserConfigurationRepository()
    )
    let testTickers: [Twenty4HourTickerForSymbolVO] = [
        Twenty4HourTickerForSymbolVO(pairSymbol: "test1USDT", price: 400.0, totalTradedQuoteAssetVolume: 1.0, changedPercent: 1.0),
        Twenty4HourTickerForSymbolVO(pairSymbol: "test2USDT", price: 100.0, totalTradedQuoteAssetVolume: 1.0, changedPercent: 1.0),
        Twenty4HourTickerForSymbolVO(pairSymbol: "test3USDT", price: 200.0, totalTradedQuoteAssetVolume: 1.0, changedPercent: 1.0),
        Twenty4HourTickerForSymbolVO(pairSymbol: "test4USDT", price: 300.0, totalTradedQuoteAssetVolume: 1.0, changedPercent: 1.0),
    ].map { ticker in
        
        var newTicker = ticker
        newTicker.setSymbols(closure: { _ in ("test", "USDT") })
        
        return newTicker
    }
    let initialState: AllMarketTickerViewModel.State = .init(
        tickerList: testTickers,
        tickerDisplayType: .list
    )
    let testComparator = StubSortComparator()
    let expectPriceListResult: [CVNumber] = [100.0, 200.0, 300.0, 400.0]
    
    // When
    let resultState = viewModel.reduce(.changeSortingCriteria(comparator: testComparator), state: initialState)
    
    
    // Then
    let priceList = resultState.tickerList.map { $0.price }
    #expect(expectPriceListResult == priceList)
}
