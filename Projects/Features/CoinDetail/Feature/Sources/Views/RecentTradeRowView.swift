//
//  RecentTradeRowView.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/15/25.
//

import SwiftUI

struct RecentTradeRowView: View {
    
    @Binding var trade: CoinTradeRO
    @State private var backgroundAlpha = 0.3
    
    var body: some View {
        HStack {
            Text(trade.priceText)
                .foregroundColor(trade.textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 3)
            
            Text(trade.quantityText)
                .foregroundColor(trade.textColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 40)
            
            Text(trade.timeText)
                .foregroundColor(trade.textColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 3)
        }
        .font(.subheadline.bold())
        .monospacedDigit()
        .padding(.vertical, 7)
        .background(trade.backgroundEffectColor.opacity(backgroundAlpha))
        .onAppear(perform: {
            withAnimation(.easeInOut(duration: 1.0)) { backgroundAlpha = 0 }
        })
        .onChange(of: trade) { _, _ in
            backgroundAlpha = 0.3
            withAnimation(.easeInOut(duration: 1.0)) { backgroundAlpha = 0 }
        }
    }
}
