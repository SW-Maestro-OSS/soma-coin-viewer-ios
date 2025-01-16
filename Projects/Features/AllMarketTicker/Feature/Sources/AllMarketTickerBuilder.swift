//
//  AllMarketTickerBuilder.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/13/25.
//

import Foundation
import Combine

import DomainInterface
import WebSocketManagementHelper

import CoreUtil
import I18N

public final class AllMarketTickerBuilder {
    
    // DI
    @Injected private var webSocketManagementHelper: WebSocketManagementHelper
    @Injected private var allMarketTickersUseCase: AllMarketTickersUseCase
    @Injected private var exchangeRateUseCase: ExchangeRateUseCase
    @Injected private var userConfigurationRepository: UserConfigurationRepository
    @Injected private var i18NManager: I18NManager
    
    private let gridTypeChangePublisher: AnyPublisher<GridType, Never>
    
    public init(gridTypeChangePublisher: AnyPublisher<GridType, Never>) {
        self.gridTypeChangePublisher = gridTypeChangePublisher
    }
    
    public func build() -> AllMarketTickerRouter {
        
        let viewModel = AllMarketTickerViewModel(
            gridTypeChangePublisher: gridTypeChangePublisher,
            socketHelper: webSocketManagementHelper,
            i18NManager: i18NManager,
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
