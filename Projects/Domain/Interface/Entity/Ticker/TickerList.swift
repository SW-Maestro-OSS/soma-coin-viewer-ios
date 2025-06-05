//
//  TickerList.swift
//  Domain
//
//  Created by choijunios on 6/5/25.
//

public struct TickerList {
    public let currencyType: CurrencyType
    public let tickers: [Ticker]
    
    public init(currencyType: CurrencyType, tickers: [Ticker]) {
        self.currencyType = currencyType
        self.tickers = tickers
    }
}
