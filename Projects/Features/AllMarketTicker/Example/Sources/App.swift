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
                    i18NManager: DependencyInjector.shared.resolve(I18NManager.self),
                    languageLocalizationRepository: DependencyInjector.shared.resolve(LanguageLocalizationRepository.self),
                    allMarketTickersUseCase: DependencyInjector.shared.resolve(AllMarketTickersUseCase.self),
                    exchangeUseCase: DependencyInjector.shared.resolve(ExchangeRateUseCase.self),
                    userConfigurationRepository: DependencyInjector.shared.resolve(UserConfigurationRepository.self),
                    alertShooter: DependencyInjector.shared.resolve(AlertShooter.self)
                )
            )

        }
    }
}
