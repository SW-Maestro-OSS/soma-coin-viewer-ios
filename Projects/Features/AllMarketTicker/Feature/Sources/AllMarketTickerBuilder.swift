//
//  AllMarketTickerBuilder.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/13/25.
//

import Foundation
import Combine

import DomainInterface
import CoinDetailFeature
import CoreUtil
import AlertShooter
import I18N
import WebSocketManagementHelper

public final class AllMarketTickerBuilder {
    
    // Service locator
    @Injected private var allMarketTickersUseCase: AllMarketTickersUseCase
    @Injected private var i18NManager: I18NManager
    @Injected private var alertShooter: AlertShooter
    @Injected private var webSocketManagementHelper: WebSocketManagementHelper
    
    public init() { }
    
    public func build(listener: AllMarketTickerPageListener) -> AllMarketTickerRoutable {
        let viewModel = AllMarketTickerViewModel(
            useCase: allMarketTickersUseCase,
            i18NManager: i18NManager,
            alertShooter: alertShooter,
            webSocketHelper: webSocketManagementHelper
        )
        viewModel.listener = listener
        let view = AllMarketTickerView(viewModel: viewModel)
        let router = AllMarketTickerRouter(view: view, viewModel: viewModel)
        return router
    }
}
