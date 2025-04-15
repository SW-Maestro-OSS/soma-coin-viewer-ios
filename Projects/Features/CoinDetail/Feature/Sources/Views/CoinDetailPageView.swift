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
                Divider()
                tickerChangeInfoContent()
                Divider()
                orderbookTableContent()
                Divider()
                recentTradeContent()
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
        .padding(.horizontal, 3)
        .padding(.bottom, 5)
    }
    
    @ViewBuilder
    private func tickerChangeInfoContent() -> some View {
        TickerChangeInfoView(info: $viewModel.state.tickerInfo)
    }
    
    @ViewBuilder
    private func orderbookTableContent() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("Qty")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Price")
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Qty")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .font(.subheadline.bold())
            .foregroundColor(.gray)
            .padding(.horizontal, 3)
            .padding(.vertical, 7)
            
            Divider()
            
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
    
    @ViewBuilder
    private func recentTradeContent() -> some View {
        RecentTradeTableView(trades: $viewModel.state.trades)
    }
}
