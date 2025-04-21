//
//  OrderbookCellRO.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/12/25.
//

import SwiftUI

struct OrderbookCellRO {
    enum TextAlignment {
        case priceFirst, quantityFirst
    }
    
    let type: OrderbookType
    let priceText: String
    var priceTextColor: Color {
        switch type {
        case .bid:
            Color.green
        case .ask:
            Color.red
        }
    }
    let quantityText: String
    var quantityGageColor: Color {
        switch type {
        case .bid:
            Color.green.opacity(0.5)
        case .ask:
            Color.red.opacity(0.5)
        }
    }
    var textAlignment: TextAlignment {
        switch type {
        case .bid:
            TextAlignment.quantityFirst
        case .ask:
            TextAlignment.priceFirst
        }
    }
    let relativePercentOfQuantity: CGFloat
}
