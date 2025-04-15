//
//  TickerChangeInfoView.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/14/25.
//

import SwiftUI

struct TickerChangeInfoView: View {
    
    @Binding var info: TickerInfo?
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .trailing),
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            Group {
                Text("Current price")
                    .padding(.horizontal, 3)
                Text(info?.currentPriceText ?? "-")
                    .foregroundStyle(.black)
                    .padding(.horizontal, 3)
                    .monospaced()
            }
            Group {
                Text("Best bid price")
                    .padding(.horizontal, 3)
                Text(info?.bestBidPriceText ?? "-")
                    .foregroundStyle(.green)
                    .padding(.horizontal, 3)
                    .monospaced()
            }
            Group {
                Text("Best ask price")
                    .padding(.horizontal, 3)
                Text(info?.bestAskPriceText ?? "-")
                    .foregroundStyle(.red)
                    .padding(.horizontal, 3)
                    .monospaced()
            }
        }
        .font(.subheadline.bold())
        .foregroundColor(.gray)
    }
}
