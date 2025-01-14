//
//  TickerGridCell.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/12/25.
//

import SwiftUI

import CommonUI

struct TickerGridCell: View {
    
    @ObservedObject private var viewModel: TickerCellViewModel
    
    init(viewModel: TickerCellViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        HStack(spacing: 0) {

            VStack(alignment: .trailing, spacing: 10) {
                
                // Sybol image + pair symbol name
                HStack(spacing: 5) {
                    
                    // Symbol image view
                    SymbolImageView(imageURL: $viewModel.state.firstSymbolImageURL)
                        .frame(width: 40, height: 40)
                    
                    // Pair symbol text
                    CVText(text: $viewModel.state.pairSymbolNameText)
                        .font(.title3)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                }
                
                HStack(spacing: 0) {
                    
                    Spacer(minLength: 0)
                    
                    VStack(alignment: .trailing) {
                        CVText(text: $viewModel.state.priceText)
                            .font(.title2)
                            .lineLimit(1)
                        
                        CVText(text: $viewModel.state.percentText)
                            .font(.title3)
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
