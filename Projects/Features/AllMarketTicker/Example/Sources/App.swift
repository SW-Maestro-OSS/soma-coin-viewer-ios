//
//  App.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI
import Combine

@testable import AllMarketTickerFeature

import DomainInterface
import CoreUtil

import AlertShooter
import I18N

@main
struct CoinViewerApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    private let stubGridTypePublisher = Just(GridType.list).eraseToAnyPublisher()
    
    var body: some Scene {
        
        WindowGroup {
          
            AllMarketTickerView(
                viewModel: .init(
                    useCase: DependencyInjector.shared.resolve(),
                    i18NManager: DependencyInjector.shared.resolve(),
                    alertShooter: DependencyInjector.shared.resolve(),
                    webSocketHelper: DependencyInjector.shared.resolve()
                )
            )

        }
    }
}
