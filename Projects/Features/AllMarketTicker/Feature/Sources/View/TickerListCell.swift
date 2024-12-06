//
//  TickerListCell.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI

struct TickerListCell: View {
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        
        LazyVGrid(columns: columns, spacing: 0) {
            
            
            
        }
    }
}
