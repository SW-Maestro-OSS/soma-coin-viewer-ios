//
//  AllMarketTickerListView.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/7/24.
//

import SwiftUI

import DomainInterface

import CommonUI

struct AllMarketTickerCollectionView: View {
    
    private var isLoaded: Bool
    private var displayType: GridType
    
    private var cellViewModels: [TickerCellViewModel]
    
    
    init(isLoaded: Bool, displayType: GridType, cellViewModels: [TickerCellViewModel]) {
        self.isLoaded = isLoaded
        self.displayType = displayType
        self.cellViewModels = cellViewModels
    }
    
    
    // Grid
    private let gridColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5),
    ]
    
    
    var body: some View {
        
        ScrollView {
            
            if isLoaded {
                
                switch displayType {
                case .list:
                    listView
                case .twoByTwo:
                    gridView
                }
                
            } else {
                
                switch displayType {
                case .list:
                    listSkeletionView
                case .twoByTwo:
                    gridSkeletionView
                }
            }
        }
    }
}


// MARK: Skeleton UI
private extension AllMarketTickerCollectionView {
    
    var listSkeletionView: some View {
        
        GeometryReader { geo in
            
            VStack(spacing: 3) {
                
                ForEach(0..<20) { _ in
                    
                    SkeletonUI()
                        .frame(width: geo.size.width, height: 45)
                        
                }
            }
        }
    }
    
    
    var gridSkeletionView: some View {
        
        LazyVGrid(columns: gridColumns, spacing: 10) {
            
            ForEach(0..<20) { _ in
                
                SkeletonUI()
                    .frame(height: 160)
            }
        }
    }
}


// MARK: Collection views
private extension AllMarketTickerCollectionView {
    
    var listView: some View {
        
        LazyVStack(spacing: 0) {
            
            ForEach(cellViewModels) { viewModel in
                
                VStack(spacing: 0) {
                    
                    TickerListCellView(viewModel: viewModel)
                        .frame(height: 50)
                    
                    Rectangle()
                        .foregroundStyle(.gray)
                        .frame(height: 1)
                        .padding(.horizontal, 1)
                }
                    
            }
        }
    }
    
    
    var gridView: some View {
        
        LazyVGrid(columns: gridColumns, spacing: 5) {
            
            ForEach(cellViewModels) { viewModel in
                
                TickerGridCell(viewModel: viewModel)
            }
        }
        .padding(5)
    }
}
