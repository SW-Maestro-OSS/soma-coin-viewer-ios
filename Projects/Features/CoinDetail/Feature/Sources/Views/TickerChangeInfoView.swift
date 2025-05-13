//
//  TickerChangeInfoView.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/14/25.
//

import SwiftUI

struct TickerChangeInfoView: View {
    
    @Binding var info: TickerInfoRO?
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .trailing),
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            Group {
                Text(info?.currentPriceTitleText ?? "")
                    .padding(.horizontal, 3)
                Text(info?.currentPriceText ?? "-")
                    .foregroundStyle(.black)
                    .padding(.horizontal, 3)
                    .monospacedDigit()
            }
            Group {
                Text(info?.bestBidPriceTitleText ?? "")
                    .padding(.horizontal, 3)
                Text(info?.bestBidPriceText ?? "-")
                    .foregroundStyle(.green)
                    .padding(.horizontal, 3)
                    .monospacedDigit()
            }
            Group {
                Text(info?.bestAskPriceTitleText ?? "")
                    .padding(.horizontal, 3)
                Text(info?.bestAskPriceText ?? "-")
                    .foregroundStyle(.red)
                    .padding(.horizontal, 3)
                    .monospacedDigit()
            }
        }
        .font(.subheadline.bold())
        .foregroundColor(.gray)
    }
}
