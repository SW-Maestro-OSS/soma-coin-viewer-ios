//
//  App.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI
import Combine

import AllMarketTickerFeature

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
            AllMarketTickerBuilder()
                .build(listener: FakeListener())
                .view
        }
    }
}

class FakeListener: AllMarketTickerPageListener {
    func request(_ request: AllMarketTickerPageListenerRequest) {
        
    }
}
