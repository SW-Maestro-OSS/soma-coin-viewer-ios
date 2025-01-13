//
//  App.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI

@testable import AllMarketTickerFeature

import WebSocketManagementHelper
import DomainInterface
import CoreUtil
import I18N

@main
struct CoinViewerApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        
        WindowGroup {
          
            AllMarketTickerView(
                viewModel: .init(
                    socketHelper: DependencyInjector.shared.resolve(WebSocketManagementHelper.self),
                    i18NManager: DependencyInjector.shared.resolve(I18NManager.self),
                    useCase: DependencyInjector.shared.resolve(AllMarketTickersUseCase.self),
                    userConfigurationRepository: DependencyInjector.shared.resolve(UserConfigurationRepository.self)
                )
            )

        }
    }
}
