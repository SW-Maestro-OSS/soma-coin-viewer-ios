//
//  StubExchangeRateRepository.swift
//  Domain
//
//  Created by choijunios on 4/24/25.
//

import DomainInterface

public struct StubExchangeRateRepository: ExchangeRateRepository {
    
    public let fixedRate: Double
    
    public init(fixedRate: Double) {
        self.fixedRate = fixedRate
    }
    
    public func prepareRates(base: DomainInterface.CurrencyType, to: [DomainInterface.CurrencyType]) async throws { }
    public func getRate(base: DomainInterface.CurrencyType, to: DomainInterface.CurrencyType) async -> Double? { return fixedRate }
}
