//
//  CoinDetailPageBuilder.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/17/25.
//

import DomainInterface
import CoreUtil

public final class CoinDetailPageBuilder {
    // Dependency
    @Injected private var coinDetailPageUseCase: CoinDetailPageUseCase
    
    public init() { }
    
    public func build(symbolInfo: CoinSymbolInfo) -> CoinDetailPageRouter {
        let viewModel = CoinDetailPageViewModel(
            symbolInfo: symbolInfo,
            useCase: coinDetailPageUseCase
        )
        let view = CoinDetailPageView(viewModel: viewModel)
        let router = CoinDetailPageRouter(
            view: view,
            viewModel: viewModel
        )
        return router
    }
}

