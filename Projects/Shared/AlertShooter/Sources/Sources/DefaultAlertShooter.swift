//
//  DefaultAlertShooter.swift
//  AlertShooter
//
//  Created by choijunios on 4/18/25.
//

import SwiftUI

import I18N

public class DefaultAlertShooter: AlertShooter {
    private var i18NManager: I18NManager
    private let shootQueue: DispatchQueue = .init(label: "shootQueue")
    
    public init(i18NManager: I18NManager) {
        self.i18NManager = i18NManager
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
        let currentLan = i18NManager.getLanguageType()
        let alertActionROs = model.actions.map { actionModel in
            let titleText = LocalizedStringProvider.instance().getString(
                key: actionModel.titleKey,
                lanCode: currentLan.lanCode
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
            messageText = LocalizedStringProvider.instance().getString(
                key: messageKey,
                lanCode: currentLan.lanCode
            )
        }
        let alertRO = AlertRO(
            titleText: LocalizedStringProvider.instance().getString(
                key: model.titleKey,
                lanCode: currentLan.lanCode
            ),
            messageText: messageText,
            actions: alertActionROs
        )
        return alertRO
    }
}
