//
//  AllMarketTickersUseCase.swift
//  Domain
//
//  Created by choijunios on 11/2/24.
//

import Combine

public protocol AllMarketTickersUseCase {
    
    /// AllMarketTicker스트림을 준비합니다.
    func prepareStream()
    
    /// AllMarketTicker리스트를 획득합니다.
    func requestTickers() -> AnyPublisher<[Twenty4HourTickerForSymbolVO], Never>
}
