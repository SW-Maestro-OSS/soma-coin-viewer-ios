//
//  AlertShooter 2.swift
//  AlertShooter
//
//  Created by choijunios on 4/18/25.
//

import SwiftUI

import I18N
import CoreUtil

public class DefaultAlertShooter: AlertShooter {
    private var i18NManager: I18NManager
    private var languageRepository: LanguageLocalizationRepository
    
    public init(i18NManager: I18NManager, languageRepository: LanguageLocalizationRepository) {
        self.i18NManager = i18NManager
        self.languageRepository = languageRepository
        super.init()
    }
    
    public override func shoot(_ model: AlertModel) {
        Task { [weak self] in
            guard let self else { return }
            await container.add(model: model)
            if alertModel == nil {
                checkAndShoot()
            }
        }
    }
    
    public override func createRO(model: AlertModel) -> AlertRO {
        let currentLan = i18NManager.getLanguageType()
        let alertActionROs = model.actions.map { actionModel in
            let titleText = languageRepository.getString(
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
            messageText = languageRepository.getString(
                key: messageKey,
                lanCode: currentLan.lanCode
            )
        }
        let alertRO = AlertRO(
            titleText: languageRepository.getString(
                key: model.titleKey,
                lanCode: currentLan.lanCode
            ),
            messageText: messageText,
            actions: alertActionROs
        )
        return alertRO
    }
}


open class AlertShooter: ObservableObject, AlertShootable {
    // State
    @Published var alertModel: AlertRO?
    @Published var present: Bool = false {
        didSet {
            if oldValue == true && present == false {
                // Alert가 닫힌 경우
                alertModel = nil
                checkAndShoot()
            }
        }
    }
    let container = AlertModelContainer()
    
    public init() { }
    
    /// 메세지 스택에서 다음 메세지를 탐색하고 Alert를 표시합니다.
    func checkAndShoot() {
        Task { [weak self] in
            guard let self else { return }
            if let model = await container.getFirst() {
                // 지연 후 Alert표츌
                try? await Task.sleep(for: .seconds(0.5))
                
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    alertModel = createRO(model: model)
                    present = true
                }
            }
        }
    }
    open func createRO(model: AlertModel) -> AlertRO { return .mock }
    
    open func shoot(_ model: AlertModel) { }
}
