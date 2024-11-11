//
//  AllMarketTickerRepository.swift
//  Domain
//
//  Created by choijunios on 11/11/24.
//

import Combine

public protocol AllMarketTickerRepository {
    
    func request24hTickerForAllSymbols() -> AnyPublisher<[Twenty4HourTickerForSymbolVO], Never>
}
