//
//  AllMarketTickers.swift
//  Domain
//
//  Created by choijunios on 11/2/24.
//

import Combine
import Foundation

import DomainInterface

public class MockAllMarketTickersRepository: AllMarketTickerRepository {
    
    public init() { }
    
    public func request24hTickerForAllSymbols() -> AnyPublisher<[DomainInterface.Twenty4HourTickerForSymbolVO], Never> {
        
        Just([]).eraseToAnyPublisher()
    }
}
