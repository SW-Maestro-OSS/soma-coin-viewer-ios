//
//  App.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/12/25.
//

import SwiftUI

import CoinDetailFeature
import WebSocketManagementHelper
import CoreUtil

@main
struct ExampleApp: App {
    
    init() {
        DependencyInjector.shared.assemble([Assemblies()])
        let webSocketHelper = DependencyInjector.shared.resolve(WebSocketManagementHelper.self)
        webSocketHelper.requestConnection(connectionType: .freshStart)
    }
    
    var body: some Scene {
        WindowGroup {
            CoinDetailPageView(viewModel: CoinDetailPageViewModel(
                symbolPair: "btcusdt",
                useCase: DependencyInjector.shared.resolve()
            ))
        }
    }
}
