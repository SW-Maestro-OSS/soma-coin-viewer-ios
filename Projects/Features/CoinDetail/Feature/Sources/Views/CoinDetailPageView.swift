//
//  CoinDetailPageView.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/12/25.
//

import SwiftUI

public struct CoinDetailPageView: View {
    
    @StateObject var viewModel: CoinDetailPageViewModel
    
    public init(viewModel: CoinDetailPageViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(spacing: 0) {
                ForEach(Array(viewModel.state.bidOrderbooks.enumerated()), id: \.offset) { index, _ in
                    OrderbookCellView(renderObject: $viewModel.state.bidOrderbooks[index])
                        .frame(height: 30)
                }
            }
            
            VStack(spacing: 0) {
                ForEach(Array(viewModel.state.askOrderbooks.enumerated()), id: \.offset) { index, _ in
                    OrderbookCellView(renderObject: $viewModel.state.askOrderbooks[index])
                        .frame(height: 30)
                }
            }
        }
        .onAppear { viewModel.action.send(.onAppear) }
    }
}
