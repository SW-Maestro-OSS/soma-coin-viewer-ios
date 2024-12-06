//
//  AllMarketTickerView.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/5/24.
//

import SwiftUI

import CoreUtil

public struct AllMarketTickerView: View {
    
    @StateObject private var viewModel: AllMarketTickerViewModel = .init()
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    public init() { }
    
    public var body: some View {
        
        ScrollView {
            
            LazyVGrid(columns: columns, spacing: 0) {
                
                ForEach(viewModel.state.sortCompartorViewModels) { viewModel in
                    
                    TickerSortSelectorView(viewModel: viewModel)
                        .frame(height: 45)
                }
                
            }
            
            LazyVStack {
                
                ForEach(viewModel.state.tickerList, id: \.symbol) { tickerVO in
                    
                    HStack {
                        
                        Text("\(tickerVO.symbol)")
                            .font(.body)
                            .foregroundStyle(.black)
                        
                        Text("\(tickerVO.price.roundToTwoDecimalPlaces())")
                            .font(.body)
                            .foregroundStyle(.black)
                        
                        Text("\(tickerVO.changedPercent.roundToTwoDecimalPlaces())")
                            .font(.body)
                            .foregroundStyle(.black)
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    
                }
            }
            
        }
    }
}
