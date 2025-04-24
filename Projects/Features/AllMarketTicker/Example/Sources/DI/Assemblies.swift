//
//  Assemblies.swift
//  AllMarketTickerFeatureExample
//
//  Created by choijunios on 11/1/24.
//

import Foundation

import AllMarketTickerFeatureTesting

import DomainInterface

import I18N
import AlertShooter
import WebSocketManagementHelper

import Swinject

public class Assemblies: Assembly {
    
    public func assemble(container: Swinject.Container) {
        
        // MARK: Shared
        container.register(I18NManager.self) { _ in
            FakeI18NManager()
        }
        .inObjectScope(.container)
        container.register(AlertShooter.self) { _ in
            MockAlertShooter()
        }
        .inObjectScope(.container)
        container.register(WebSocketManagementHelper.self) { _ in
            MockWebSocketManagementHelper()
        }
        .inObjectScope(.container)
        
        // MARK: Domain
        container.register(AllMarketTickersUseCase.self) { _ in
            FakeAllMarketTickerUseCase()
        }
    }
}
