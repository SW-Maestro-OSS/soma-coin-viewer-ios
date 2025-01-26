//
//  Fake.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/14/25.
//

import Combine

import DomainInterface

class FakeExchangeRateUseCase: ExchangeRateUseCase {
    
    func getExchangeRate(base: DomainInterface.CurrencyType, to: DomainInterface.CurrencyType) -> AnyPublisher<Double, Never> {
        
        return Just(1.0).eraseToAnyPublisher()
    }
    
    func prepare() { }
}
