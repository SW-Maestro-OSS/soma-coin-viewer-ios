//
//  TickerCellRO.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/23/25.
//

import SwiftUI

import CoreUtil

struct TickerCellRO: Identifiable {
    var id: String { self.symbolText }
    let symbolText: String
    let symbolImageURL: String
    var priceText: String
    var changePercentText: String
    var changePercentTextColor: Color
}
