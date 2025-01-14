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
    @ObservedObject private var viewModel: TickerSortSelectorViewModel
    
    // View state
    @State private var backgroundOpacity: CGFloat = 0.0
    
    private var store: Set<AnyCancellable> = []
    
    init(viewModel: TickerSortSelectorViewModel) {
        
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        ZStack {
            if viewModel.state.isLoading {
                SkeletonUI()
            } else {
                Group {
                    Rectangle()
                        .foregroundStyle(.gray.opacity(0.5))
                        .opacity(backgroundOpacity)
                    
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
            }
        }
        .onTapGesture {
            
            // Send action
            viewModel.action.send(.tap)
            
            // Click animation
            backgroundOpacity = 1.0
            withAnimation { backgroundOpacity = 0.0 }
        }
    }
}
