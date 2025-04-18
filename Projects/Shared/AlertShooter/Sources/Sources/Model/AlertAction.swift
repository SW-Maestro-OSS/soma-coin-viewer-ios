//
//  AlertAction.swift
//  AlertShooter
//
//  Created by choijunios on 1/31/25.
//

import Foundation

public struct AlertAction: Sendable, Identifiable {
    public let id: UUID = .init()
    public let titleKey: String
    public let role: Role
    public let action: (@Sendable () -> Void)?
    
    public init(titleKey: String, role: Role = .normal, action: (@Sendable () -> Void)? = nil) {
        self.titleKey = titleKey
        self.role = role
        self.action = action
    }
    
    public enum Role: Sendable {
        case normal
        case cancel
    }
}
