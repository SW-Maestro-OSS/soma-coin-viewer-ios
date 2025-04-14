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
        LazyVGrid(columns: columns) {
            Group {
                Text("Current price")
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 3)
                Text(info?.currentPriceText ?? "-")
                    .foregroundStyle(.black)
                    .padding(.horizontal, 3)
            }
            Group {
                Text("Best bid price")
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 3)
                Text(info?.bestBidPriceText ?? "-")
                    .foregroundStyle(.green)
                    .padding(.horizontal, 3)
            }
            Group {
                Text("Best ask price")
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 3)
                Text(info?.bestAskPriceText ?? "-")
                    .foregroundStyle(.red)
                    .padding(.horizontal, 3)
            }
        }
    }
}
