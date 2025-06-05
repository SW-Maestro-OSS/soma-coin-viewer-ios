//
//  StubExchangeRateRepository.swift
//  Domain
//
//  Created by choijunios on 4/24/25.
//

import DomainInterface

public class StubExchangeRateRepository: ExchangeRateRepository {
    
    private var container: [String: Double] = [:]
    
    public init() { }
    
    public func set(base: CurrencyType, to: CurrencyType, rate: Double) {
        container[base.symbol+to.symbol] = rate
    }
    
    public func prepareRates(base: DomainInterface.CurrencyType, to: [DomainInterface.CurrencyType]) async throws { }
    public func getRate(base: DomainInterface.CurrencyType, to: DomainInterface.CurrencyType) async -> Double? {
        container[base.symbol+to.symbol]
    }
}
