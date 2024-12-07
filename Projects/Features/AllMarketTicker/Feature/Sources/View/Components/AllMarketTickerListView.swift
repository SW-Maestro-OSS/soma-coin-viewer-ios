//
//  AllMarketTickerListView.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/7/24.
//

import SwiftUI

import CommonUI

struct AllMarketTickerListView: View {
    
    private var isLoaded: Bool
    
    @Binding private var listItems: [TickerListCellViewModel]
    
    init(isLoaded: Bool, listItems: Binding<[TickerListCellViewModel]>) {
        self.isLoaded = isLoaded
        self._listItems = listItems
    }
    
    var body: some View {
        
        if isLoaded {
            
            ScrollView {
                
                LazyVStack(spacing: 3) {
                    
                    ForEach(listItems) { viewModel in
                        
                        VStack {
                            
                            TickerListCellView(viewModel: viewModel)
                                .frame(height: 45)
                            
                            
                            Rectangle()
                                .foregroundStyle(.gray)
                                .frame(height: 1)
                                .padding(.horizontal, 1)
                        }
                            
                    }
                }
            }
        } else {
            
            GeometryReader { geo in
                
                VStack(spacing: 3) {
                    
                    ForEach(0..<20) { _ in
                        
                        SkeletonUI()
                            .frame(width: geo.size.width, height: 45)
                            
                    }
                }
            }
        }
        
    }
}
