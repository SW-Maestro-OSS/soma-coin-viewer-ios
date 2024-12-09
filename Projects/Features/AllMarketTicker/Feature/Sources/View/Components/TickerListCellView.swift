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
    
    @State private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                LazyVGrid(columns: columns, spacing: 0) {
                    
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
                    
                    
                    // MARK: Price
                    HStack {
                        CVText(text: $viewModel.state.priceText)
                            .font(.body)
                            .lineLimit(1)
                        Spacer(minLength: 0)
                    }
                    
                    
                    // MARK: 24h change percent
                    HStack {
                        CVText(text: $viewModel.state.percentText)
                            .font(.body)
                            .lineLimit(1)
                        Spacer(minLength: 0)
                    }
                }
                Spacer(minLength: 0)
            }
            .onAppear {
                
                let width = geo.size.width
                
                columns = [
                    GridItem(.fixed(width * 0.4)),
                    GridItem(.fixed(width * 0.3)),
                    GridItem(.fixed(width * 0.3)),
                ]
            }
        }
    }
}
