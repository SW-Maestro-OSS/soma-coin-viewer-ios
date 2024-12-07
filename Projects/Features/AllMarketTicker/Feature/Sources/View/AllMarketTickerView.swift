//
//  AllMarketTickerView.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/5/24.
//

import SwiftUI

import CommonUI
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
            .background {
                Rectangle()
                    .foregroundStyle(.gray.opacity(0.3))
                    .background { Rectangle().foregroundStyle(.white) }
                    .padding(.vertical, 1)
                    .background {
                        Rectangle().foregroundStyle(.black)
                    }
            }
            
            // MARK: Ticker list
            AllMarketTickerListView(
                isLoaded: viewModel.state.isLoaded,
                listItems: $viewModel.state.tickerListCellViewModels
            )
            
        }
    }
}
