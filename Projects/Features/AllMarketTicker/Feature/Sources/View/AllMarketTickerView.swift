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
        .onAppear { viewModel.action(.view(.onAppear)) }
        .onDisappear { viewModel.action(.view(.onDisappear)) }
        .onChange(of: scenePhase) { oldValue, newValue in
            if oldValue == .background && (newValue == .active || newValue == .inactive) {
                viewModel.action(.view(.getBackToForeground))
            } else if newValue == .background {
                viewModel.action(.view(.enterBackground))
            }
        }
    }
    
    @ViewBuilder
    private func sortSelectionTabContent() -> some View {
        LazyVGrid(columns: sortSelectionViewColumn, spacing: 0) {
            ForEach(viewModel.state.sortSelectionCells, id: \.sortType) { ro in
                TickerSortSelectorView(renderObject: ro)
                    .frame(height: 45)
                    .onTapGesture {
                        viewModel.action(.view(.sortSelectionButtonTapped(type: ro.sortType)))
                    }
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
                        ForEach(viewModel.state.tickerCellRenderObjects) { item in
                            VStack(spacing: 0) {
                                TickerListCellView(renderObject: item)
                                    .frame(height: 50)
                                    .onTapGesture {
                                        viewModel.action(.view(.coinRowIsTapped(coinInfo: item)))
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
                        ForEach(viewModel.state.tickerCellRenderObjects) { item in
                            TickerGridCell(renderObject: item)
                                .onTapGesture {
                                    viewModel.action(.view(.coinRowIsTapped(coinInfo: item)))
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
