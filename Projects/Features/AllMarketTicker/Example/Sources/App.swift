//
//  App.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI

@testable import AllMarketTickerFeature

import WebSocketManagementHelperInterface
import DomainInterface
import CoreUtil

@main
struct CoinViewerApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        
        WindowGroup {
            
            AllMarketTickerView(
                viewModel: .init(
                    socketHelper: DependencyInjector.shared.resolve(WebSocketManagementHelper.self),
                    useCase: DependencyInjector.shared.resolve(AllMarketTickersUseCase.self)
                )
            )
        }
    }
}
