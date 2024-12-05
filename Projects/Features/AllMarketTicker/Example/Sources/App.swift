//
//  App.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI

import AllMarketTickerFeature

@main
struct CoinViewerApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        
        WindowGroup {
            
            AllMarketTickerView()
        }
    }
}
