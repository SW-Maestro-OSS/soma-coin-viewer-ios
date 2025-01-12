//
//  TickerGridCell.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/12/25.
//

import SwiftUI

struct TickerGridCell: View {
    
    @State var imageURLString: String
    @State var pairSymbolNameText: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            // Sybol image + pair symbol name
            HStack(spacing: 5) {
                
                // Symbol image view
                SymbolImageView(imageURL: $imageURLString)
                    .frame(width: 40, height: 40)
                
                // Pair symbol text
                Text(pairSymbolNameText)
                    .font(.title3)
                    .lineLimit(1)
            }
            
            HStack {
                
                Rectangle().frame(width: 40, height: 0)
                
                VStack(alignment: .trailing, spacing: 10) {
                    
                    Text("63.240.01")
                        .font(.title2)
                    
                    Text("+3.12%")
                        .font(.title3)
                        
                }
            }
        }
        .padding(10)
        .background(.gray.opacity(0.2))
        .border(.black, width: 1)
    }
}

#Preview {
    TickerGridCell(
        imageURLString: "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/refs/heads/master/32/icon/btc.png",
        pairSymbolNameText: "BTCUSDT"
    )
}
