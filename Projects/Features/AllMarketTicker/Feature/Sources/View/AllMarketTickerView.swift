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
    private let sortSelectionViewColumn: [GridItem] = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
    ]
    
    // Ticker view
    private let tickerGridColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5),
    ]
    
    
    init(viewModel: AllMarketTickerViewModel) {
        
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // MARK: Sort selection view
            LazyVGrid(columns: sortSelectionViewColumn, spacing: 0) {
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
            ScrollView {
                let displayType = viewModel.state.tickerGridType
                if viewModel.state.isLoaded {
                    switch displayType {
                    case .list:
                        tickerListView
                    case .twoByTwo:
                        tickerGridView
                    }
                } else {
                    switch displayType {
                    case .list:
                        tickerListSkeletonView
                    case .twoByTwo:
                        tickerGridSkeletonView
                    }
                }
            }
        }
        .onAppear { viewModel.action(.onAppear) }
    }
}


// MARK: Ticker collection view
private extension AllMarketTickerView {
    var tickerListView: some View {
        LazyVStack(spacing: 0) {
            ForEach(viewModel.state.tickerCellRO) { ro in
                VStack(spacing: 0) {
                    TickerListCellView(renderObject: ro)
                        .frame(height: 50)
                    Rectangle()
                        .foregroundStyle(.gray)
                        .frame(height: 1)
                        .padding(.horizontal, 1)
                }
            }
        }
    }
    var tickerGridView: some View {
        LazyVGrid(columns: tickerGridColumns, spacing: 5) {
            ForEach(viewModel.state.tickerCellRO) {
                TickerGridCell(renderObject: $0)
            }
        }
        .padding(5)
    }
}


// MARK: SkeletonUI for ticker list
private extension AllMarketTickerView {
    var tickerListSkeletonView: some View {
        GeometryReader { geo in
            VStack(spacing: 3) {
                ForEach(0..<20) { _ in
                    SkeletonUI()
                        .frame(width: geo.size.width, height: 45)
                }
            }
        }
    }
    var tickerGridSkeletonView: some View {
        LazyVGrid(columns: tickerGridColumns, spacing: 10) {
            ForEach(0..<20) { _ in
                SkeletonUI()
                    .frame(height: 160)
            }
        }
    }
}
