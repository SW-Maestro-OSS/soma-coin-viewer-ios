//
//  OrderbookCellView.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/13/25.
//

import SwiftUI

struct OrderbookCellView: View {
    
    @Binding var renderObject: OrderbookCellRO
    
    var body: some View {
        ZStack {
            quantityGageContent()
            HStack { textContent() }
        }
    }
    
    @ViewBuilder
    private func quantityGageContent() -> some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                switch renderObject.textAlignment {
                case .priceFirst:
                    Rectangle()
                        .frame(
                            width: geo.size.width/2 * renderObject.relativePercentOfQuantity,
                            height: geo.size.height
                        )
                        .foregroundStyle(renderObject.quantityGageColor)
                        .animation(.easeInOut(duration: 0.3), value: renderObject.relativePercentOfQuantity)
                    Spacer(minLength: geo.size.width/2)
                case .quantityFirst:
                    Spacer(minLength: geo.size.width/2)
                    Rectangle()
                        .frame(width: geo.size.width/2 * renderObject.relativePercentOfQuantity, height: geo.size.height)
                        .foregroundStyle(renderObject.quantityGageColor)
                        .animation(.easeInOut(duration: 0.3), value: renderObject.relativePercentOfQuantity)
                }
            }
        }
    }
    
    @ViewBuilder
    private func textContent() -> some View {
        switch renderObject.textAlignment {
        case .priceFirst:
            Text(renderObject.priceText)
                .foregroundStyle(renderObject.priceTextColor)
            Spacer()
            Text(renderObject.quantityText)
                .foregroundStyle(.black)
        case .quantityFirst:
            Text(renderObject.quantityText)
                .foregroundStyle(.black)
            Spacer()
            Text(renderObject.priceText)
                .foregroundStyle(renderObject.priceTextColor)
        }
    }
}
