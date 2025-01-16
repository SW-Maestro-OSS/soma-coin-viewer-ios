//
//  Tests.swift
//
//

import Combine
import Testing

@testable import AllMarketTickerFeatureTesting
@testable import AllMarketTickerFeature

import DomainInterface
import CoreUtil
import I18N

struct AllMarketTickerViewModelTests {
    
    init() {
        DependencyInjector.shared.register(
            LanguageLocalizationRepository.self,
            DefaultLanguageLocalizationRepository()
        )
        DependencyInjector.shared.register(
            I18NManager.self,
            FakeI18NManager()
        )
    }
    
    @Test
    func testSortingComparator() {
        
        // Given
        let viewModel = AllMarketTickerViewModel(
            gridTypeChangePublisher: Just(GridType.list).eraseToAnyPublisher(),
            socketHelper: FakeWebSocketHelper(),
            i18NManager: FakeI18NManager(),
            allMarketTickersUseCase: FakeAllMarketTickersUseCase(),
            exchangeUseCase: StubExchangeUseCase(),
            userConfigurationRepository: FakeUserConfigurationRepository()
        )
        let givenTickerCellViewModels: [TickerCellViewModel] = [
            Twenty4HourTickerForSymbolVO(pairSymbol: "test1USDT", price: 400.0, totalTradedQuoteAssetVolume: 1.0, changedPercent: 1.0),
            Twenty4HourTickerForSymbolVO(pairSymbol: "test2USDT", price: 100.0, totalTradedQuoteAssetVolume: 1.0, changedPercent: 1.0),
            Twenty4HourTickerForSymbolVO(pairSymbol: "test3USDT", price: 200.0, totalTradedQuoteAssetVolume: 1.0, changedPercent: 1.0),
            Twenty4HourTickerForSymbolVO(pairSymbol: "test4USDT", price: 300.0, totalTradedQuoteAssetVolume: 1.0, changedPercent: 1.0),
        ].map { ticker in
            var newTicker = ticker
            newTicker.setSymbols(closure: { _ in ("test", "USDT") })
            return TickerCellViewModel(config: .init(
                tickerVO: newTicker,
                currencyConfig: .init(type: .dollar, rate: 1.0))
            )
        }
        let initialState: AllMarketTickerViewModel.State = .init(
            sortComparator: AscendingPriceSortComparator(),
            tickerDisplayType: .list,
            tickerCellViewModels: givenTickerCellViewModels
        )
        let ascendingPriceSortComparator = AscendingPriceSortComparator()
        
        
        // When
        // - 정렬 기준을 가격에 의한 오름차순으로 설정
        let resultState = viewModel.reduce(
            .changeSortingCriteria(comparator: ascendingPriceSortComparator),
            state: initialState
        )
        
        
        // Then
        // - 정렬이 올바르게 진행됬는지 확인
        let expectedResult = initialState.tickerCellViewModels
            .map { $0.tickerVO.price }
            .sorted(by: { $0.wrappedNumber < $01.wrappedNumber })
        let priceList = resultState.tickerCellViewModels.map { $0.tickerVO.price }
        #expect(expectedResult == priceList)
    }
}

