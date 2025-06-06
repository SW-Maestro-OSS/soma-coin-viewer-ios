//
//  TickerListCellView.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI

import CommonUI

import SimpleImageProvider

struct TickerListCellView: View {
    
    private let renderObject: TickerCellRO
    
    init(renderObject: TickerCellRO) {
        self.renderObject = renderObject
    }
    
    var body: some View {
        GeometryReader { geo in
            
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                
                HStack(spacing: 0) {
                    
                    // MARK: Symbol image + text
                    
                    GeometryReader { geo1 in
                        HStack(alignment: .center, spacing: 5) {
                            
                            // Symbol image view
                            SymbolImageView(imageURL: .constant(renderObject.symbolImageURL))
                                .frame(width: geo1.size.width*0.2, height: geo1.size.width*0.2)
                            
                            // Pair symbol text
                            Text(renderObject.symbolText)
                                .font(.subheadline)
                                .lineLimit(1)
                                
                            Spacer(minLength: 0)
                        }
                        .frame(width: geo1.size.width, height: geo1.size.height)
                    }
                    .padding(.leading, 10)
                    .frame(width: geo.size.width * 0.33)
                    
                    
                    // MARK: Price
                    HStack(spacing: 0) {
                        Spacer(minLength: 0)
                        Text(renderObject.priceText)
                            .font(.footnote)
                            .lineLimit(1)
                    }
                    .frame(width: geo.size.width * 0.33)
                    
                    
                    // MARK: 24h change percent
                    HStack(spacing: 0) {
                        Spacer(minLength: 0)
                        Text(renderObject.changePercentText)
                            .font(.body)
                            .foregroundStyle(renderObject.changePercentTextColor)
                            .lineLimit(1)
                    }
                    .padding(.trailing, 10)
                    .frame(width: geo.size.width * 0.33)
                }
                Spacer(minLength: 0)
            }
        }
        .background { Rectangle().foregroundStyle(.white) }
    }
}
