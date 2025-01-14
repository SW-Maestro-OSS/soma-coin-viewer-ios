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

class TabBarBuilder {
    
    func build() -> TabBarRouter {
        
        let gridTypeChangePublisher = PassthroughSubject<GridType, Never>()
        
        let viewModel = TabBarViewModel(gridTypeChangePublisher: gridTypeChangePublisher)
        let view = TabBarView(viewModel: viewModel)
        let allMarketTickerBuilder = AllMarketTickerBuilder(
            gridTypeChangePublisher: gridTypeChangePublisher.eraseToAnyPublisher()
        )
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
