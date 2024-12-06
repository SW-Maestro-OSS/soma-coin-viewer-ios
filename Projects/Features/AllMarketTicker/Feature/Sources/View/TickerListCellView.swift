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
                
                // First symbol image
                SimpleImage(
                    url: viewModel.state.firstSymbolImageURL,
                    size: .init(width: 33, height: 33)
                )
                
                // Pair symbol text
                CVText(text: $viewModel.state.pairSymbolName)
                
            }
            
            // MARK: Price
            CVText(text: $viewModel.state.price)
            
            
            // MARK: 24h change percent
            CVText(text: $viewModel.state.percent)
        }
    }
}
