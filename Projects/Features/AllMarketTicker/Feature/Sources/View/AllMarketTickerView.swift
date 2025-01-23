//
//  AllMarketTickerView.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/5/24.
//

import SwiftUI

import CommonUI
import CoreUtil

struct AllMarketTickerView: View {
    
    @StateObject private var viewModel: AllMarketTickerViewModel
    
    
    // Sort selection view
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
    ]
    
    
    init(viewModel: AllMarketTickerViewModel) {
        
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // MARK: Sort selection view
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(viewModel.state.displayingSortSelectionCellROs) { ro in
                    Group {
                        if viewModel.state.isLoaded {
                            TickerSortSelectorView(renderObject: ro)
                                .onTapGesture {
                                    viewModel.action(.sortSelectionButtonTapped(type: ro.type))
                                }
                        } else { SkeletonUI() }
                    }
                    .frame(height: 45)
                }
            }
            
            // MARK: Ticker collection view
            AllMarketTickerCollectionView(
                isLoaded: viewModel.state.isLoaded,
                displayType: viewModel.state.tickerDisplayType,
                cellViewModels: viewModel.state.tickerCellViewModels
            )
        }
        .onAppear { viewModel.action(.onAppear) }
    }
}
