//
//  DefaultAllMarketTickerPageUseCase.swift
//  Domain
//
//  Created by choijunios on 11/2/24.
//

import Foundation
import Combine

import DomainInterface
import CoreUtil

public class DefaultAllMarketTickerPageUseCase: AllMarketTickerPageUseCase {
    
    @Injected var allMarketTickerRepository: (any AllMarketTickerRepository)
    
    public init() { }
    
    public func getList(count: Int) -> AnyPublisher<[Symbol24hTickerVO], Never> {
        
        allMarketTickerRepository
            .subscribe()
            .throttle(for: 0.35, scheduler: DispatchQueue.global(), latest: true)
            .catch { error in
                
                // 에러 처리
                
                return Just([])
            }
            .map { tickers in
                
                // QuoteAssetVolume을 사용하요 내림차순 정렬
                let sortedTickers = tickers.sorted { lhs, rhs in
                    lhs.totalTradedQuoteAssetVolume > rhs.totalTradedQuoteAssetVolume
                }
                
                // 상위 30개만 전달
                if sortedTickers.count > 30 {
                    return Array(sortedTickers[0..<30])
                }
                
                return sortedTickers
            }
            .eraseToAnyPublisher()
    }
}
