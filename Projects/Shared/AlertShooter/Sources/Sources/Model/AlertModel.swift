//
//  AlertModel.swift
//  AlertShooter
//
//  Created by choijunios on 1/31/25.
//

import I18N

public struct AlertModel: Sendable {
    // State
    public let titleKey: LocalizedStrKey
    public let messageKey: LocalizedStrKey?
    public private(set) var actions: [AlertAction] = []
    
    public init(titleKey: LocalizedStrKey, messageKey: LocalizedStrKey?) {
        self.titleKey = titleKey
        self.messageKey = messageKey
    }
    
    @discardableResult
    public mutating func add(action: AlertAction) -> Self {
        self.actions.append(action)
        return self
    }
}
