//
//  PriceChangePercentRO.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/16/25.
//

import SwiftUI

enum ChangeType {
    case plus, neutral, minus
    
    var imageName: String? {
        switch self {
        case .plus:
            "arrowtriangle.up.fill"
        case .neutral:
            nil
        case .minus:
            "arrowtriangle.down.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .plus:
            Color.green
        case .neutral:
            Color.black
        case .minus:
            Color.red
        }
    }
}

struct PriceChangePercentRO {
    var changeType: ChangeType
    var percentText: String
}
