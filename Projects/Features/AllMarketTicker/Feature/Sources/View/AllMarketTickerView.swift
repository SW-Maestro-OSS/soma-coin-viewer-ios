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
    @Environment(\.scenePhase) var scenePhase
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
            sortSelectionTabContent()
            tickerListContent()
        }
        .onAppear { viewModel.send(.view(.onAppear)) }
        .onDisappear { viewModel.send(.view(.onDisappear)) }
    }
    
    @ViewBuilder
    private func sortSelectionTabContent() -> some View {
        LazyVGrid(columns: sortSelectionViewColumn, spacing: 0) {
            ForEach(Array(0..<viewModel.state.sortSelectionCount), id: \.self) { index in
                let item = viewModel.state.sortSelectionModels[index]
                TickerSortSelectorView(model: item) { [weak viewModel] in
                    viewModel?.send(.view(.sortSelectionButtonTapped(index: index)))
                }
                .frame(height: 45)
                .skeleton(presentOrigin: viewModel.state.isLoaded)
            }
        }
    }
    
    @ViewBuilder
    private func tickerListContent() -> some View {
        ScrollView {
            let displayType = viewModel.state.tickerGridType
            if viewModel.state.isLoaded {
                switch displayType {
                case .list:
                    LazyVStack(spacing: 0) {
                        ForEach(Array(0..<viewModel.state.tickerCellCount), id: \.self) { index in
                            let item = viewModel.state.tickerCellModels[index]
                            
                            VStack(spacing: 0) {
                                TickerListCellView(renderObject: item)
                                    .frame(height: 50)
                                    .onTapGesture {
                                        viewModel.send(.view(.tickerRowTapped(index: index)))
                                    }
                                Rectangle()
                                    .foregroundStyle(.gray)
                                    .frame(height: 1)
                                    .padding(.horizontal, 1)
                            }
                        }
                    }
                case .twoByTwo:
                    LazyVGrid(columns: tickerGridColumns, spacing: 5) {
                        ForEach(Array(0..<viewModel.state.tickerCellCount), id: \.self) { index in
                            let item = viewModel.state.tickerCellModels[index]
                            
                            TickerGridCell(renderObject: item)
                                .onTapGesture {
                                    viewModel.send(.view(.tickerRowTapped(index: index)))
                                }
                        }
                    }
                    .padding(5)
                }
            } else {
                switch displayType {
                case .list:
                    GeometryReader { geo in
                        VStack(spacing: 3) {
                            ForEach(Array(0..<viewModel.state.tickerRowCount), id: \.self) { _ in
                                SkeletonUI()
                                    .frame(width: geo.size.width, height: 45)
                            }
                        }
                    }
                case .twoByTwo:
                    LazyVGrid(columns: tickerGridColumns, spacing: 10) {
                        ForEach(Array(0..<viewModel.state.tickerRowCount), id: \.self) { _ in
                            SkeletonUI()
                                .frame(height: 160)
                        }
                    }
                }
            }
        }
    }
}
