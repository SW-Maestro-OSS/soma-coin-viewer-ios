//
//  CoinDetailPageView.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/12/25.
//

import SwiftUI

struct CoinDetailPageView: View {
    
    @StateObject var viewModel: CoinDetailPageViewModel
    
    init(viewModel: CoinDetailPageViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                coinTitleContent()
                tickerChangeInfoContent()
                orderbookTableContent()
            }
        }
        .onAppear { viewModel.action.send(.onAppear) }
    }
    
    @ViewBuilder
    private func coinTitleContent() -> some View {
        HStack {
            Text(viewModel.state.symbolText)
                .font(.title)
                .foregroundStyle(.black)
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 5)
        
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(.black)
    }
    
    @ViewBuilder
    private func tickerChangeInfoContent() -> some View {
        TickerChangeInfoView(info: $viewModel.state.tickerInfo)
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(.black)
    }
    
    @ViewBuilder
    private func orderbookTableContent() -> some View {
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
    }
}
