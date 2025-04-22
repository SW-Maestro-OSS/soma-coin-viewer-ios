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
    
    var displayPriceText: String
    var displayChangePercentText: String
    var displayChangePercentTextColor: Color
    
    // For sort
    let symbolPair: String
    let price: CVNumber
    let changedPercent: CVNumber
    let firstSymbol: String
    let secondSymbol: String
}
