//
//  AlertModel.swift
//  AlertShooter
//
//  Created by choijunios on 1/31/25.
//

import Foundation

public struct AlertModel {
    
    // Imformation
    public let titleKey: String
    public let messageKey: String?
    public private(set) var actions: [AlertAction] = []
    
    public init(titleKey: String, messageKey: String?) {
        self.titleKey = titleKey
        self.messageKey = messageKey
    }
    
    @discardableResult
    public mutating func add(action: AlertAction) -> Self {
        self.actions.append(action)
        return self
    }
}
