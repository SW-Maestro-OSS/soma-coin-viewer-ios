//
//  AlertRO.swift
//  RootModule
//
//  Created by choijunios on 1/31/25.
//

import SwiftUI

struct AlertRO {
    let titleText: String
    let messageText: String?
    let actions: [AlertActionRO]
}

struct AlertActionRO: Identifiable {
    let id: UUID = .init()
    
    let titleText: String
    let titleTextColor: Color
    
    let action: (() -> Void)?
}
