//
//  StubAllMaketTickerRepository.swift
//  Domain
//
//  Created by choijunios on 4/24/25.
//

import Combine

import DomainInterface
import CoreUtil

public struct StubAllMarketTickerRepository: AllMarketTickersRepository {
    
    private var tickers: [Ticker]
    
    public init(tickers: [Ticker]) {
        self.tickers = tickers
    }
    
    public func getTickers() -> AnyPublisher<[Ticker], Never> {
        Future<[Ticker], Never> { promise in
            promise(.success(tickers))
        }
        .eraseToAnyPublisher()
    }
    
}
