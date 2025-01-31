//
//  AlertAction.swift
//  AlertShooter
//
//  Created by choijunios on 1/31/25.
//

import SwiftUI

public struct AlertAction {

    public typealias ActionRole = ButtonRole
    
    public let titleKey: String
    public let actionRole: ActionRole
    public let action: (() -> Void)?
    
    public init(titleKey: String, actionRole: ActionRole = .cancel, action: (() -> Void)? = nil) {
        self.titleKey = titleKey
        self.actionRole = actionRole
        self.action = action
    }
}
