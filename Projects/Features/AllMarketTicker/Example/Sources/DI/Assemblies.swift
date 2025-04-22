//
//  Assemblies.swift
//  AllMarketTickerFeatureExample
//
//  Created by choijunios on 11/1/24.
//

import Foundation

@testable import AllMarketTickerFeatureTesting

import DomainInterface

import I18N
import AlertShooter

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
        
        
        // MARK: Repository
        container.register(UserConfigurationRepository.self) { _ in
            FakeUserConfigurationRepository()
        }
        .inObjectScope(.container)
    }
}
