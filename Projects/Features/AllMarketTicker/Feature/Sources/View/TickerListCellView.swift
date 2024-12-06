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
                    ImageView(imageURL: $viewModel.state.firstSymbolImageURL)
                }
                
                // Pair symbol text
                Spacer(minLength: 0)
                    .overlay(alignment: .leading) {
                        CVText(text: $viewModel.state.pairSymbolNameText)
                            .font(.subheadline)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    
            }
            .padding(.leading, 10)
            
            // MARK: Price
            GeometryReader { geo in
                CVText(text: $viewModel.state.priceText)
                    .font(.body)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .leading)
                    .padding(.leading, geo.size.width * 0.25)
            }
            
            
            // MARK: 24h change percent
            GeometryReader { geo in
                CVText(text: $viewModel.state.percentText)
                    .font(.body)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .leading)
                    .padding(.leading, geo.size.width * 0.25)
            }
        }
    }
}
