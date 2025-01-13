//
//  AllMarketTickerBuilder.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/13/25.
//

import Foundation

import DomainInterface
import WebSocketManagementHelper

import CoreUtil

public class AllMarketTickerBuilder {
    
    // DI
    @Injected private var webSocketManagementHelper: WebSocketManagementHelper
    @Injected private var allMarketTickersUseCase: AllMarketTickersUseCase
    @Injected private var userConfigurationRepository: UserConfigurationRepository
    
    
    public init() { }
    
    public func build() -> AllMarketTickerRouter {
        
        let viewModel = AllMarketTickerViewModel(
            socketHelper: webSocketManagementHelper,
            useCase: allMarketTickersUseCase,
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
