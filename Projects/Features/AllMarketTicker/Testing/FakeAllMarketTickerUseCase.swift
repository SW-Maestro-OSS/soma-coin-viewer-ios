//
//  FakeAllMarketTickerUseCase.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 4/24/25.
//

import Foundation
import Combine

import DomainInterface
import CoreUtil

public final class FakeAllMarketTickerUseCase: AllMarketTickersUseCase {
    
    public init() { }
    
    public func getTickerListStream() -> AnyPublisher<TickerList, Never> {
        let tickers = (0..<500).map { index in
            Ticker(
                pairSymbol: PairSymbol(
                    firstSymbol: "BTC\(index)",
                    secondSymbol: "USDT"
                ),
                price: Decimal(100 * index),
                totalTradedQuoteAssetVolume: Decimal(100 * index),
                changedPercent: Decimal(100 * index),
                bestBidPrice: Decimal(100 * index),
                bestAskPrice: Decimal(100 * index)
            )
        }
        let publisher = CurrentValueSubject<TickerList, Never>(TickerList(currencyType: .dollar, tickers: tickers))
        return publisher.eraseToAnyPublisher()
    }
    
    public func getGridType() -> GridType { .list }
}
