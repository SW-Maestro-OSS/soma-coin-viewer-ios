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
    
    @Injected var repository: AllMarketTickersRepository
    
    private let throttleTimerQueue: DispatchQueue = .init(
        label: "com.AllMarketTickersUseCase",
        attributes: .concurrent
    )
    
    public init() { }
    
    public func requestTickers(
        maxCount: Int,
        cuttingStyle: CuttingStyle,
        sortOperator: @escaping SortOperator) -> AnyPublisher<[Twenty4HourTickerForSymbolVO], Never> {
        
        repository
            .request24hTickerForAllSymbols()
            .throttle(for: 0.3, scheduler: throttleTimerQueue, latest: true)
            .map { tickers in
                
                let sortedTickers = tickers.sorted(by: sortOperator)
                
                let listSize = sortedTickers.count
                
                if listSize < maxCount {
                    
                    return sortedTickers
                }
                
                // 커팅
                if case .begining = cuttingStyle {
                    
                    return Array(sortedTickers[0..<maxCount])
                } else {
                    
                    let startPoint = listSize - maxCount
                    
                    return Array(sortedTickers[startPoint..<listSize])
                }
            }
            .eraseToAnyPublisher()
    }
}
