//
//  TabBarBuilder.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

import SwiftUI
import Combine

import DomainInterface
import AllMarketTickerFeature
import SettingFeature
import CoinDetailFeature
import BaseFeature
import I18N
import CoreUtil

class TabBarBuilder {
    // Dependency
    @Injected private var i18NManager: I18NManager
    @Injected private var languageLocalizationRepository: LanguageLocalizationRepository
    
    func build() -> TabBarRouter {
        let viewModel = TabBarViewModel(
            i18NManager: i18NManager,
            languageRepository: languageLocalizationRepository
        )
        let view = TabBarView(viewModel: viewModel)
        let allMarketTickerBuilder = AllMarketTickerBuilder()
        let settingBuilder = SettingBuilder()
        let coinDetailPageBuilder = CoinDetailPageBuilder()
        let router = TabBarRouter(
            view: view,
            viewModel: viewModel,
            settingBuilder: settingBuilder,
            allMarketTickerBuilder: allMarketTickerBuilder,
            coinDetailPageBuilder: coinDetailPageBuilder
        )
        return router
    }
}
