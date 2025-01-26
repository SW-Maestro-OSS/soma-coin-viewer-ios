//
//  StubEmptyAllMarketTickerUseCase.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/25/25.
//

import Combine

import DomainInterface


class StubEmptyAllMarketTickerUseCase: AllMarketTickersUseCase {
    
    init() { }
    
    func prepareStream() { }
    
    func requestTickers() -> AnyPublisher<[DomainInterface.Twenty4HourTickerForSymbolVO], Never> {
        
        Just([]).eraseToAnyPublisher()
    }
}
