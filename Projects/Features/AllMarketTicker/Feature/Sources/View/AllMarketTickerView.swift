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
    
    init(viewModel: AllMarketTickerViewModel) {
        
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // MARK: Sort selection
            SortSelectionContainerView(viewModels: viewModel.sortCompartorViewModels)
            
            // MARK: Ticker list
            AllMarketTickerListView(
                isLoaded: viewModel.state.isLoaded,
                displayType: .grid,
                cellViewModels: viewModel.state.tickerCellViewModels
            )
        }
    }
}
