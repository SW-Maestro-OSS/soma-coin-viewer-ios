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
import BaseFeature

import I18N
import CoreUtil

class TabBarBuilder {
    
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
        let router = TabBarRouter(
            settingBuilder: settingBuilder,
            allMarketTickerBuilder: allMarketTickerBuilder,
            view: view,
            viewModel: viewModel
        )
        
        return router
    }
}
