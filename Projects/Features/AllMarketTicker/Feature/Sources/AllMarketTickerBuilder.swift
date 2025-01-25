//
//  AllMarketTickerBuilder.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/13/25.
//

import Foundation
import Combine

import DomainInterface

import CoreUtil
import I18N

public final class AllMarketTickerBuilder {
    
    // Service locator
    @Injected private var allMarketTickersUseCase: AllMarketTickersUseCase
    @Injected private var exchangeRateUseCase: ExchangeRateUseCase
    @Injected private var userConfigurationRepository: UserConfigurationRepository
    @Injected private var i18NManager: I18NManager
    @Injected private var languageLocalizationRepository: LanguageLocalizationRepository
    
    public init() { }
    
    public func build() -> AllMarketTickerRouter {
        
        let viewModel = AllMarketTickerViewModel(
            i18NManager: i18NManager,
            languageLocalizationRepository: languageLocalizationRepository,
            allMarketTickersUseCase: allMarketTickersUseCase,
            exchangeUseCase: exchangeRateUseCase,
            userConfigurationRepository: userConfigurationRepository
        )
        let view = AllMarketTickerView(viewModel: viewModel)
        let router = AllMarketTickerRouter(
            view: view,
            viewModel: viewModel
        )
        return router
    }
}
