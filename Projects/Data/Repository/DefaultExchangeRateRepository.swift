//
//  DefaultExchangeRateInKRWRepository.swift
//  Data
//
//  Created by 최준영 on 01/13/25.
//

import Foundation
import Combine

import DomainInterface

import DataSource

import CoreUtil

public final class DefaultExchangeRateRepository: ExchangeRateRepository {
    // Dependency
    @Injected private var exchangeRateDataSource: ExchangeRateDataSource
    
    public init() { }
}


// MARK: ExchangeRateRepository
public extension DefaultExchangeRateRepository {
    func prepareRates(base: CurrencyType, to: [CurrencyType]) async throws {
        try await exchangeRateDataSource.prepareRates(base: base.currencyCode, to: to.map(\.currencyCode))
    }
    
    func getRate(base: CurrencyType, to: CurrencyType) async -> Double? {
        let dto = await exchangeRateDataSource.getExchangeRate(base: base.currencyCode)
        return dto?.rates[to.currencyCode]
    }
}
