//
//  AlertActionConfig.swift
//  AlertShooter
//
//  Created by choijunios on 1/31/25.
//

import SwiftUI

public struct AlertActionConfig {
    
    public let textColor: Color
    
    public init(textColor: Color) {
        self.textColor = textColor
    }
    
    public static let `default`: Self = .init(textColor: .black)
}
