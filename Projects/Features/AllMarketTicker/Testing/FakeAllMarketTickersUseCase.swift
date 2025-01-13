//
//  FakeAllMarketTickersUseCase.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/13/25.
//

import Combine

import DomainInterface

class FakeAllMarketTickersUseCase: AllMarketTickersUseCase {
    
    init() { }
    
    func requestTickers() -> AnyPublisher<[DomainInterface.Twenty4HourTickerForSymbolVO], Never> {
        
        Just([]).eraseToAnyPublisher()
    }
}
