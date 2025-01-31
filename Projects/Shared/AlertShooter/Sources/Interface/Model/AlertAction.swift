//
//  AlertAction.swift
//  AlertShooter
//
//  Created by choijunios on 1/31/25.
//

public struct AlertAction {

    public let titleKey: String
    public let config: AlertActionConfig
    public let action: (() -> Void)?
    
    public init(titleKey: String, config: AlertActionConfig = .default, action: (() -> Void)? = nil) {
        self.titleKey = titleKey
        self.action = action
        self.config = config
    }
}
