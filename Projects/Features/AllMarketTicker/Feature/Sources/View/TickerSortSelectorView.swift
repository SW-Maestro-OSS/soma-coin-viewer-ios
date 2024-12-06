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
        
        Button {
            
            viewModel.action.send(.tap)
            
        } label: {
            
            ZStack {
                
                Rectangle()
                    .foregroundStyle(backgroundColor)
                    .onTapGesture {
                        
                        backgroundColor = .gray.opacity(0.35)
                        
                        withAnimation {
                            backgroundColor = .white
                        }
                    }
                
                HStack(spacing: 10) {
                    
                    Image(systemName: viewModel.state.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10)
                    
                    CVText(text: $viewModel.state.title)
                }
                .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    TickerSortSelectorView(
        viewModel: .init(
            title: "Symbol",
            ascendingComparator: TickerSymbolAscendingComparator(),
            descendingComparator: TickerSymbolDescendingComparator()
        )
    )
}
