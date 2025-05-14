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

    public init() { }
    
    public func build(listener: AllMarketTickerPageListener) -> AllMarketTickerRoutable {
        let viewModel = AllMarketTickerViewModel(
            useCase: DependencyInjector.shared.resolve(),
            alertShooter: DependencyInjector.shared.resolve(),
            webSocketHelper: DependencyInjector.shared.resolve(),
            i18NManager: DependencyInjector.shared.resolve(),
            localizedStrProvider: DependencyInjector.shared.resolve()
        )
        viewModel.listener = listener
        let view = AllMarketTickerView(viewModel: viewModel)
        let router = AllMarketTickerRouter(view: view, viewModel: viewModel)
        return router
    }
}
