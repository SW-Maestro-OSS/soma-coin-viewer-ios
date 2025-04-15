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
                .monospacedDigit()
                .padding(.horizontal)
            
            Text(trade.quantityText)
                .foregroundColor(trade.textColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .monospacedDigit()
                .padding(.trailing, 40)
            
            Text(trade.timeText)
                .foregroundColor(trade.textColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .monospacedDigit()
                .padding(.horizontal)
        }
        .font(.system(size: 14))
        .padding(.vertical, 5)
        .background(trade.backgroundEffectColor.opacity(backgroundAlpha))
        .onAppear(perform: {
            withAnimation(.easeInOut(duration: 0.2)) { backgroundAlpha = 0 }
        })
        .onChange(of: trade) { _, _ in
            backgroundAlpha = 0.3
            withAnimation(.easeInOut(duration: 0.2)) { backgroundAlpha = 0 }
        }
    }
}
