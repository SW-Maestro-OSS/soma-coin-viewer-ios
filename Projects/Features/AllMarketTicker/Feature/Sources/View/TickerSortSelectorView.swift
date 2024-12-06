//
//  TickerSortSelectorView.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI
import Combine

import CommonUI

struct TickerSortSelectorView: View {
    
    // ViewModel
    @StateObject private var viewModel: TickerSortSelectorViewModel
    
    // View state
    @State private var backgroundColor: Color = .white
    
    private var store: Set<AnyCancellable> = []
    
    init(viewModel: TickerSortSelectorViewModel) {
        
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        ZStack {
            
            Rectangle()
                .foregroundStyle(backgroundColor)
            
            HStack(spacing: 10) {
                
                Image(systemName: viewModel.state.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
                
                CVText(text: $viewModel.state.title)
                    .font(.caption)
                    .lineLimit(1)
            }
            .foregroundStyle(.black)
        }
        .frame(height: 45)
        .onTapGesture {
            
            viewModel.action.send(.tap)
            
            // Click animation
            backgroundColor = .gray.opacity(0.2)
            withAnimation {
                backgroundColor = .white
            }
        }
    }
}

#Preview {
    TickerSortSelectorView(
        viewModel: .init(
            id: "test",
            title: "Symbol",
            ascendingComparator: TickerSymbolAscendingComparator(),
            descendingComparator: TickerSymbolDescendingComparator()
        )
    )
}
