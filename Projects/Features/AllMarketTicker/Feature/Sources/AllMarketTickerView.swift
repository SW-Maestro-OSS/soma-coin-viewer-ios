//
//  AllMarketTickerView.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/5/24.
//

import SwiftUI

public struct AllMarketTickerView: View {
    
    @StateObject private var viewModel: AllMarketTickerViewModel = .init()
    
    public init() { }
    
    public var body: some View {
        
        ScrollView {
            
            LazyVStack {
                
                ForEach(viewModel.state.tickerList, id: \.symbol) { tickerVO in
                    
                    HStack {
                        
                        Text("\(tickerVO.symbol)")
                            .font(.title3)
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
