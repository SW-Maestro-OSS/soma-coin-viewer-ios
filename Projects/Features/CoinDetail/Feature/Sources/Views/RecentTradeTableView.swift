//
//  RecentTradeTableView.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/15/25.
//

import SwiftUI

struct RecentTradeTableView: View {
    
    @Binding var trades: [CoinTradeRO]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Price")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Qty")
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Time")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .font(.subheadline.bold())
            .foregroundColor(.gray)
            .padding(.horizontal, 3)
            .padding(.vertical, 8)
            
            Divider()
            
            // Rows
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(trades.enumerated()), id: \.element.id) { index, _ in
                        RecentTradeRowView(trade: $trades[index])
                    }
                }
            }
        }
    }
}
