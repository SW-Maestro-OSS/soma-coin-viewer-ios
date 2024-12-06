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
    
    @ObservedObject private var viewModel: TickerListCellViewModel
    
    init(viewModel: TickerListCellViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        
        LazyVGrid(columns: columns, spacing: 0) {
            
            // MARK: Symbol image + text
            HStack(spacing: 5) {
                
                ZStack {
                 
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.gray.opacity(0.5))
                    
                    // First symbol image
                    Group {
                        
                        if let image = viewModel.state.firstSymbolImage {
                            
                            Image(uiImage: image)
                                .transition(.opacity)
                        }
                    }
                }
                
                // Pair symbol text
                CVText(text: $viewModel.state.pairSymbolNameText)
                    .font(.caption2)
                    .lineLimit(1)
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 10)
            
            // MARK: Price
            CVText(text: $viewModel.state.priceText)
                .font(.body)
            
            
            // MARK: 24h change percent
            CVText(text: $viewModel.state.percentText)
                .font(.body)
        }
    }
}
