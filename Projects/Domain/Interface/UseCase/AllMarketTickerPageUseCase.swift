//
//  AllMarketTickerPageUseCase.swift
//  Domain
//
//  Created by choijunios on 11/2/24.
//

import Combine

public protocol AllMarketTickerPageUseCase {
    
    /// AllMarketTicker리스트를 획득합니다.
    func getList(count: Int) -> AnyPublisher<[Symbol24hTickerVO], Never>
}
