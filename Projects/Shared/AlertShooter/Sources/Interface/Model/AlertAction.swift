//
//  AlertAction.swift
//  AlertShooter
//
//  Created by choijunios on 1/31/25.
//

public struct AlertAction {

    public let titleKey: String
    public let role: Role
    public let action: (() -> Void)?
    
    public init(titleKey: String, role: Role = .normal, action: (() -> Void)? = nil) {
        self.titleKey = titleKey
        self.role = role
        self.action = action
    }
    
    public enum Role {
        case normal
        case cancel
    }
}
