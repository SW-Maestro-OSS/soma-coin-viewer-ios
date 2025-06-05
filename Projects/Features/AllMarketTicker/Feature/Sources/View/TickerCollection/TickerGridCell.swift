//
//  TickerGridCell.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/12/25.
//

import SwiftUI

import CommonUI

struct TickerGridCell: View {
    
    private let renderObject: TickerCellRO
    
    init(renderObject: TickerCellRO) {
        self.renderObject = renderObject
    }
    
    var body: some View {
        
        HStack(spacing: 0) {

            VStack(alignment: .trailing, spacing: 10) {
                
                // Sybol image + pair symbol name
                HStack(spacing: 5) {
                    
                    // Symbol image view
                    SymbolImageView(imageURL: .constant(renderObject.symbolImageURL))
                        .frame(width: 40, height: 40)
                    
                    // Pair symbol text
                    Text(renderObject.symbolText)
                        .font(.title3)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                }
                
                HStack(spacing: 0) {
                    
                    Spacer(minLength: 0)
                    
                    VStack(alignment: .trailing) {
                        Text(renderObject.priceText)
                            .font(.title2)
                            .lineLimit(1)
                        
                        Text(renderObject.changePercentText)
                            .font(.title3)
                            .foregroundStyle(renderObject.changePercentTextColor)
                            .lineLimit(1)
                    }
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(10)
        .background(.gray.opacity(0.2))
        .border(.black, width: 1)
    }
}
