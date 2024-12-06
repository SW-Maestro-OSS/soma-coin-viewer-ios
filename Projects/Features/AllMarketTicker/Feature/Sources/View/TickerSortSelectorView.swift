//
//  TickerSortSelectorView.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI

import CommonUI

struct TickerSortSelectorView: View {
    
    // ViewModel
    @StateObject var viewModel: TickerSortSelectorViewModel
    
    // View state
    @State private var backgroundColor: Color = .white
    
    init(viewModel: TickerSortSelectorViewModel) {
        
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        Button {
            
            
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
            imageName: "chevron.up.chevron.down",
            ascendingComparator: TickerSymbolAscendingComparator(),
            descendingComparator: TickerSymbolDescendingComparator()
        )
    )
}
