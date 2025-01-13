//
//  SortSelectionContainerView.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/7/24.
//

import SwiftUI

struct SortSelectionContainerView: View {
    
    private let sortSelectionViewModels: [TickerSortSelectorViewModel]
    
    init(viewModels: [TickerSortSelectorViewModel]) {
        
        self.sortSelectionViewModels = viewModels
    }
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        
        LazyVGrid(columns: columns, spacing: 0) {
            
            ForEach(sortSelectionViewModels) { viewModel in
                
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
    }
}
