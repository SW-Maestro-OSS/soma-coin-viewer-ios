//
//  DefaultAllMarketTickersUseCase.swift
//  Domain
//
//  Created by choijunios on 11/2/24.
//

import Foundation
import Combine

import DomainInterface
import CoreUtil

public class DefaultAllMarketTickersUseCase: AllMarketTickersUseCase {
    
    @Injected private var repository: AllMarketTickersRepository
    
    private let throttleTimerQueue: DispatchQueue = .init(
        label: "com.AllMarketTickersUseCase",
        attributes: .concurrent
    )
    
    public init() { }
    
    public func requestTickers() -> AnyPublisher<[Twenty4HourTickerForSymbolVO], Never> {
        
        repository
            .request24hTickerForAllSymbols()
            .throttle(for: 0.3, scheduler: throttleTimerQueue, latest: true)
            .map { fetchedTickers in
                
                // MARK: #1. Filter symbols that dont cotain USDT as suffix
                
                fetchedTickers.filter { vo in
                    
                    vo.symbol.hasSuffix("USDT")
                }
                
            }
            .map { usdtTickers in
                
                // MARK: #2. Sort tickers
                
                usdtTickers.sorted { ticker1, ticker2 in
                    
                    ticker1.totalTradedQuoteAssetVolume > ticker2.totalTradedQuoteAssetVolume
                }
            }
            .map { sortedTickers in
                
                // MARK: #3. Cut 30 tickes
                
                let listSize = sortedTickers.count
                
                if listSize < 30 {
                    
                    return sortedTickers
                }
                
                return Array(sortedTickers[0..<30])
            }
            .eraseToAnyPublisher()
    }
}
