//
//  TradeContainer.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/15/25.
//

import DomainInterface

actor TradeContainer {
    private let maxCount: Int
    private var trades: [CoinTradeVO]
    
    init(maxCount: Int, trades: [CoinTradeVO] = []) {
        self.maxCount = maxCount
        self.trades = trades
    }
    
    func insert(element newTrade: CoinTradeVO) {
        if !trades.contains(where: { $0.tradeId == newTrade.tradeId }) {
            trades.append(newTrade)
            trades.sort(by: { $0.tradeTime > $1.tradeTime })
            if trades.count > maxCount {
                trades = Array(trades.prefix(upTo: maxCount))
            }
        }
    }
    
    func getList() -> [CoinTradeVO] { return trades }
}
