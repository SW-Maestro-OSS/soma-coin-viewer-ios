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
    
    public init() { }
    
    public var body: some View {
        
        VStack {
            
            // MARK: Sort selection
            SortSelectionContainerView(
                sortSelectionViewModels: $viewModel.state.sortCompartorViewModels
            )
            
            // MARK: Ticker list
            AllMarketTickerListView(
                isLoaded: viewModel.state.isLoaded,
                listItems: $viewModel.state.tickerListCellViewModels
            )
            
        }
    }
}
