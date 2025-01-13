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
    
    @ObservedObject private var viewModel: TickerCellViewModel
    
    init(viewModel: TickerCellViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                
                HStack(spacing: 0) {
                    
                    // MARK: Symbol image + text
                    HStack(spacing: 5) {
                        
                        // Symbol image view
                        SymbolImageView(imageURL: $viewModel.state.firstSymbolImageURL)
                            .frame(width: 40, height: 40)
                        
                        // Pair symbol text
                        CVText(text: $viewModel.state.pairSymbolNameText)
                            .font(.subheadline)
                            .lineLimit(1)
                            
                        Spacer(minLength: 0)
                    }
                    .padding(.leading, 10)
                    .frame(width: geo.size.width * 0.33)
                    
                    
                    // MARK: Price
                    HStack(spacing: 0) {
                        Spacer(minLength: 0)
                        CVText(text: $viewModel.state.priceText)
                            .font(.footnote)
                            .lineLimit(1)
                    }
                    .frame(width: geo.size.width * 0.33)
                    
                    
                    // MARK: 24h change percent
                    HStack(spacing: 0) {
                        Spacer(minLength: 0)
                        CVText(text: $viewModel.state.percentText)
                            .font(.body)
                            .lineLimit(1)
                    }
                    .padding(.trailing, 10)
                    .frame(width: geo.size.width * 0.33)
                }
                Spacer(minLength: 0)
            }
        }
    }
}
