//
//  FakeExchangeRateRepository.swift
//  CoinDetailModule
//
//  Created by choijunios on 5/13/25.
//

import DomainInterface

public class FakeExchangeRateRepository: ExchangeRateRepository {
    
    public init() { }
    
    public func prepareRates(base: DomainInterface.CurrencyType, to: [DomainInterface.CurrencyType]) async throws {
        
    }
    
    public func getRate(base: DomainInterface.CurrencyType, to: DomainInterface.CurrencyType) async -> Double? {
        1.0
    }
}
