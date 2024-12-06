//
//  AllMarketTickerView.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/5/24.
//

import SwiftUI

import CoreUtil

public struct AllMarketTickerView: View {
    
    @StateObject private var viewModel: AllMarketTickerViewModel = .init()
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    public init() { }
    
    public var body: some View {
        
        VStack {
            
            // MARK: Sort selection
            LazyVGrid(columns: columns, spacing: 0) {
                
                ForEach(viewModel.state.sortCompartorViewModels) { viewModel in
                    
                    TickerSortSelectorView(viewModel: viewModel)
                        .frame(height: 45)
                }
            }
            
            // MARK: Ticker list
            ScrollView {
                
                LazyVStack(spacing: 3) {
                    
                    ForEach(viewModel.state.tickerListCellViewModels) { viewModel in
                        
                        TickerListCellView(viewModel: viewModel)
                            .frame(height: 45)
                    }
                }
            }
        }
    }
}
