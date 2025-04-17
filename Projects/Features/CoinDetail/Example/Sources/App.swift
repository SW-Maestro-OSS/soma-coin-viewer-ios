//
//  App.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/12/25.
//

import SwiftUI

@testable import CoinDetailFeature
import WebSocketManagementHelper
import CoreUtil

@main
struct ExampleApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    private let listener = FakeListener()
    
    var body: some Scene {
        WindowGroup {
            CoinDetailPageView(viewModel: CoinDetailPageViewModel(
                listener: listener,
                symbolInfo: .init(firstSymbol: "xrp", secondSymbol: "usdt"),
                useCase: DependencyInjector.shared.resolve()
            ))
        }
    }
}

class FakeListener: CoinDetailPageListener {
    func request(_ request: CoinDetailPageListnerRequest) {
        print(request)
    }
}

@MainActor
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        // 의존성 주입
        DependencyInjector.shared.assemble([Assemblies()])
        let webSocketHelper = DependencyInjector.shared.resolve(WebSocketManagementHelper.self)
        webSocketHelper.requestConnection(connectionType: .freshStart)
        
        sleep(2)
        
        return true
    }
}
