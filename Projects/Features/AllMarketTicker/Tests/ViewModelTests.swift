//
//  Tests.swift
//
//

import Testing

@testable import AllMarketTickerFeatureTesting
@testable import AllMarketTickerFeature

import DomainInterface
import CoreUtil

/// 테스트 제목: AllmarketTicker의 특정항목을 잘 정렬하는지 검사
///
/// 

@Test
func sortingTest() {
    
    let viewModel = AllMarketTickerViewModel(
        socketHelper: MockWebSocketHelper(),
        useCase: MockAllMarketTickersUseCase()
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
        sortCompartorViewModels: []
    )
    
    let testComparator = TestSortComparator()
    
    let expectPriceListResult: [CVNumber] = [100.0, 200.0, 300.0, 400.0]
    
    
    let resultState = viewModel.reduce(.changeSortingCriteria(comparator: testComparator), state: initialState)
    let priceList = resultState.tickerList.map { $0.price }
    
    #expect(expectPriceListResult == priceList)
}
