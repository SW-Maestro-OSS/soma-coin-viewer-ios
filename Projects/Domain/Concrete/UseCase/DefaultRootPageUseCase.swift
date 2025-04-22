//
//  DefaultRootPageUseCase.swift
//  Domain
//
//  Created by choijunios on 4/22/25.
//

import DomainInterface

import CoreUtil

public final class DefaultRootPageUseCase: RootPageUseCase {
    // Dependency
    @Injected private var exchangeRateRepository: ExchangeRateRepository
    
    public init() { }
    
    public func prepareExchangeRate() async throws {
        try await exchangeRateRepository.prepareRates(base: .dollar, to: [.won])
    }
}
