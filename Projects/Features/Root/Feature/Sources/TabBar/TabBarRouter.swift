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
            let router = allMarketTickerBuilder.build(listener: viewModel)
            if let allMarketTickerRouter { dettach(allMarketTickerRouter) }
            allMarketTickerRouter = router
            attach(router)
            return router.view
        case .setting:
            let router = settingBuilder.build(listener: viewModel)
            if let settingRouter { dettach(settingRouter) }
            settingRouter = router
            attach(router)
            return router.view
        }
    }
    
    func view(_ destination: TabBarPageDestination) -> AnyView {
        switch destination {
        case .coinDetailPage(let listener, let symbolInfo):
            let router = coinDetailPageBuilder.build(listener: listener, symbolInfo: symbolInfo)
            if let coinDetailPageRouter { dettach(coinDetailPageRouter) }
            coinDetailPageRouter = router
            attach(router)
            return router.view
        }
    }
}
