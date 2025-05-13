//
//  CoinDetailPageBuilder.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/17/25.
//

import DomainInterface
import CoreUtil
import WebSocketManagementHelper

public final class CoinDetailPageBuilder {
    
    public init() { }
    
    public func build(listener: CoinDetailPageListener, symbolInfo: CoinSymbolInfo) -> CoinDetailPageRoutable {
        let viewModel = CoinDetailPageViewModel(
            symbolInfo: symbolInfo,
            useCase: DependencyInjector.shared.resolve(),
            i18NManager: DependencyInjector.shared.resolve(),
            webSocketManagementHelper: DependencyInjector.shared.resolve()
        )
        viewModel.listener = listener
        let view = CoinDetailPageView(viewModel: viewModel)
        let router = CoinDetailPageRouter(
            view: view,
            viewModel: viewModel
        )
        return router
    }
}

