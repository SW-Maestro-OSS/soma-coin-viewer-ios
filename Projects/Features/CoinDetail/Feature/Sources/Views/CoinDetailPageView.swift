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
        HStack(alignment: .top, spacing: 10) {
            VStack(spacing: 0) {
                
                ForEach(Array(viewModel.state.bidOrderbooks.enumerated()), id: \.offset) { _, bidItem in
                    HStack {
                        Text(bidItem.quantityText)
                            .foregroundStyle(.green)
                            .font(.system(size: 10))
                        Spacer()
                        Text(bidItem.priceText)
                            .font(.system(size: 10))
                    }
                    .frame(height: 20)
                }
            }
            
            VStack(spacing: 0) {
                ForEach(Array(viewModel.state.askOrderbooks.enumerated()), id: \.offset) { _, askItem in
                    HStack {
                        Text(askItem.priceText)
                            .font(.system(size: 10))
                        Spacer()
                        Text(askItem.quantityText)
                            .foregroundStyle(.red)
                            .font(.system(size: 10))
                    }
                    .frame(height: 20)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                viewModel.action.send(.onAppear)
            }
        }
    }
}
