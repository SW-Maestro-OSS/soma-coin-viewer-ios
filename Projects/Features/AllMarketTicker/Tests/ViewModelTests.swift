//
//  Tests.swift
//
//

import Combine
import Testing
import Foundation

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
    @MainActor
    func checkPriceSortingComparator() async {
        
        // Given
        let viewModel = AllMarketTickerViewModel(
            i18NManager: FakeI18NManager(),
            languageLocalizationRepository: StubLanguageLocalizationRepository(),
            allMarketTickersUseCase: StubEmptyAllMarketTickerUseCase(),
            exchangeUseCase: StubExchangeUseCase(),
            userConfigurationRepository: FakeUserConfigurationRepository(),
            alertShooter: MockAlertShooter()
        )
        let givenTickerVOs: [Twenty4HourTickerForSymbolVO] = [
            Twenty4HourTickerForSymbolVO(pairSymbol: "test4USDT", price: 200.0, totalTradedQuoteAssetVolume: 1.0, changedPercent: 1.0),
            Twenty4HourTickerForSymbolVO(pairSymbol: "test3USDT", price: 100.0, totalTradedQuoteAssetVolume: 1.0, changedPercent: 2.0),
            Twenty4HourTickerForSymbolVO(pairSymbol: "test2USDT", price: 300.0, totalTradedQuoteAssetVolume: 1.0, changedPercent: 3.0),
            Twenty4HourTickerForSymbolVO(pairSymbol: "test1USDT", price: 400.0, totalTradedQuoteAssetVolume: 1.0, changedPercent: 4.0),
        ].map { vo in
            var newVO = vo
            newVO.setSymbols(closure: { pairSymbol in
                let firstSymbol = pairSymbol.replacingOccurrences(of: "USDT", with: "")
                let secondSymbol = "USDT"
                return (firstSymbol, secondSymbol)
            })
            return newVO
        }
        // emit(2)
        viewModel.action.send(.i18NUpdated(
            languageType: .english,
            currenyType: .dollar,
            exchangeRate: 1.0)
        )
        // emit(3)
        viewModel.action.send(.tickerListFetched(list: givenTickerVOs))
        
        
        // #1. When
        // - 정렬 기준을 가격에 의한 오름차순으로 설정
        // emit(4)
        viewModel.action.send(.sortSelectionButtonTapped(type: .price))

        
        // #1. Then
        // - 정렬이 올바르게 진행됬는지 확인, descending price sort
        let expectedSymbolArray = givenTickerVOs.sorted { lhs, rhs in
            lhs.price > rhs.price
        }.map({ $0.pairSymbol.uppercased() })
        for await state in viewModel.$state.dropFirst(3).values {
            let sortedSymbols = state.tickerCellRO.map({ $0.symbolText.uppercased() })
            #expect(sortedSymbols == expectedSymbolArray)
            break
        }
    }
}

