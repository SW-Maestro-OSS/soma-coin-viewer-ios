//
//  TabBarRouter.swift
//  RootModule
//
//  Created by choijunios on 1/13/25.
//

import SwiftUI

import SettingFeature
import AllMarketTickerFeature
import CoinDetailFeature
import BaseFeature

protocol TabBarViewModelable: SettingPageListener, AllMarketTickerPageListener {
    func updateDestinationPath(path: NavigationPath)
}

class TabBarRouter: Router<TabBarViewModelable>, TabBarRouting {
    // State
    private var path: NavigationPath = .init()
    
    // Builder
    private let allMarketTickerBuilder: AllMarketTickerBuilder
    private let settingBuilder: SettingBuilder
    private let coinDetailPageBuilder: CoinDetailPageBuilder
    
    // Router
    private var allMarketTickerRouter: AllMarketTickerRoutable?
    private var settingRouter: SettingRoutable?
    private var coinDetailPageRouter: CoinDetailPageRoutable?
    
    
    init(
        view: TabBarView,
        viewModel: TabBarViewModel,
        settingBuilder: SettingBuilder,
        allMarketTickerBuilder: AllMarketTickerBuilder,
        coinDetailPageBuilder: CoinDetailPageBuilder
    ) {
        self.settingBuilder = settingBuilder
        self.allMarketTickerBuilder = allMarketTickerBuilder
        self.coinDetailPageBuilder = coinDetailPageBuilder
        super.init(view: AnyView(view), viewModel: viewModel)
        viewModel.router = self
    }
}


// MARK: TabBarRouting
extension TabBarRouter {
    func request(_ request: TabBarRoutingRequest) {
        switch request {
        case .presentCoinDetailPage(let listener, let symbolInfo):
            path.append(TabBarPageDestination.coinDetailPage(listener: listener, symbolInfo: symbolInfo))
            viewModel.updateDestinationPath(path: path)
        case .dismissCoinDetailPage:
            guard let coinDetailPageRouter else { return }
            self.coinDetailPageRouter = nil
            dettach(coinDetailPageRouter)
            path.removeLast()
            viewModel.updateDestinationPath(path: path)
        }
    }
    
    func getPath() -> Binding<NavigationPath> {
        Binding(get: { [weak self] in
            self?.path ?? .init()
        }, set: { [weak self] newPath in
            self?.path = newPath
        })
    }
    
    func tabBarPage(_ page: TabBarPage) -> AnyView {
        switch page {
        case .allMarketTicker:
            getAllMarketTickerPageRouter().view
        case .setting:
            getSettingPageRouter().view
        }
    }
    
    func view(_ destination: TabBarPageDestination) -> AnyView {
        switch destination {
        case .coinDetailPage(let listener, let symbolInfo):
            getCoinDetailPageRouter(listener: listener, symbolInfo: symbolInfo).view
        }
    }
}


// MARK: Create routers
private extension TabBarRouter {
    func getAllMarketTickerPageRouter() -> AllMarketTickerRoutable {
        if let allMarketTickerRouter { return allMarketTickerRouter }
        let router = allMarketTickerBuilder.build(listener: viewModel)
        allMarketTickerRouter = router
        attach(router)
        return router
    }
    
    func getSettingPageRouter() -> SettingRoutable {
        if let settingRouter { return settingRouter }
        let router = settingBuilder.build(listener: viewModel)
        settingRouter = router
        attach(router)
        return router
    }
    
    func getCoinDetailPageRouter(listener: CoinDetailPageListener, symbolInfo: CoinSymbolInfo) -> CoinDetailPageRoutable {
        if let coinDetailPageRouter { return coinDetailPageRouter }
        let router = coinDetailPageBuilder.build(listener: listener, symbolInfo: symbolInfo)
        coinDetailPageRouter = router
        attach(router)
        return router
    }
}
