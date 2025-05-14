//
//  DefaultAlertShooter.swift
//  AlertShooter
//
//  Created by choijunios on 4/18/25.
//

import SwiftUI

import I18N

public class DefaultAlertShooter: AlertShooter {
    // Dependency
    private var i18NManager: I18NManager
    private var localizedStrProvider: LocalizedStrProvider
    
    
    // Util
    private let shootQueue: DispatchQueue = .init(label: "shootQueue")
    
    
    public init(i18NManager: I18NManager, localizedStrProvider: LocalizedStrProvider) {
        self.i18NManager = i18NManager
        self.localizedStrProvider = localizedStrProvider
        super.init()
    }
    
    public override func shoot(_ model: AlertModel) {
        shootQueue.sync { [weak self] in
            guard let self else { return }
            container.add(model: model)
            if alertModel == nil {
                checkAndShoot()
            }
        }
    }
    
    public override func createRO(model: AlertModel) -> AlertRO {
        let languageType = i18NManager.getLanguageType()
        let alertActionROs = model.actions.map { actionModel in
            let titleText = localizedStrProvider.getString(
                key: actionModel.titleKey,
                languageType: languageType
            )
            var titleTextColor: Color!
            switch actionModel.role {
            case .normal:
                titleTextColor = .black
            case .cancel:
                titleTextColor = .red
            }
            return AlertActionRO(
                titleText: titleText,
                titleTextColor: titleTextColor,
                action: actionModel.action
            )
        }
        
        // Alert RO
        var messageText: String = ""
        if let messageKey = model.messageKey {
            messageText = localizedStrProvider.getString(
                key: messageKey,
                languageType: languageType
            )
        }
        let alertRO = AlertRO(
            titleText: localizedStrProvider.getString(
                key: model.titleKey,
                languageType: languageType
            ),
            messageText: messageText,
            actions: alertActionROs
        )
        return alertRO
    }
}
