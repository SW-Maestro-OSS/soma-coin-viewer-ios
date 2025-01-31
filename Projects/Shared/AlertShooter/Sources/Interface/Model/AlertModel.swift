//
//  AlertModel.swift
//  AlertShooter
//
//  Created by choijunios on 1/31/25.
//

import Foundation

public struct AlertModel {
    
    // Imformation
    public let title: String
    public let message: String?
    public private(set) var actions: [AlertAction] = []
    
    public init(title: String, message: String?) {
        self.title = title
        self.message = message
    }
    
    @discardableResult
    public mutating func add(action: AlertAction) -> Self {
        self.actions.append(action)
        return self
    }
}
