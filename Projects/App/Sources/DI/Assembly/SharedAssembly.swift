//
//  SharedAssembly.swift
//  CoinViewer
//
//  Created by choijunios on 12/4/24.
//

import DataSource

import WebSocketManagementHelper
import AlertShooter

import Swinject
import I18N

public class SharedAssembly: Assembly {
    
    public func assemble(container: Swinject.Container) {
        
        // MARK: WebSocketManagementHelper
        container.register(WebSocketManagementHelper.self) { resolver in
            DefaultWebSocketManagementHelper(
                webSocketService: resolver.resolve(WebSocketService.self)!,
                alertShootable: resolver.resolve(AlertShooter.self)!
            )
        }
        .inObjectScope(.container)
        
        // MARK: LanguageLocalizationRepository
        container.register(LanguageLocalizationRepository.self) { _ in
            DefaultLanguageLocalizationRepository()
        }
        .inObjectScope(.container)
        
        //MARK: I18NManager
        container.register(I18NManager.self) { _ in
            DefaultI18NManager()
        }
        .inObjectScope(.container)
        
        // MARK: AlertShooter
        container.register(AlertShooter.self) { resolver in
            DefaultAlertShooter(
                i18NManager: resolver.resolve(I18NManager.self)!,
                languageRepository: resolver.resolve(LanguageLocalizationRepository.self)!
            )
        }
        .inObjectScope(.container)
    }
}
