//
//  AlertRO.swift
//  AlertShooter
//
//  Created by choijunios on 4/18/25.
//

import Foundation

import SwiftUI

public struct AlertRO {
    public let titleText: String
    public let messageText: String?
    public let actions: [AlertActionRO]
    
    public static let mock: AlertRO = .init(titleText: "Error", messageText: nil, actions: [
        .init(titleText: "close", titleTextColor: .black, action: nil)
    ])
}

public struct AlertActionRO: Identifiable {
    public let id: UUID = .init()
    public let titleText: String
    public let titleTextColor: Color
    public let action: (@Sendable () -> Void)?
}
