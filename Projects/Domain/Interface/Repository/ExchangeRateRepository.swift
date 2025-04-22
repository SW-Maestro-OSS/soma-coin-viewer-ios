//
//  ExchangeRateInKRWRepository.swift
//  Domain
//
//  Created by 최준영 on 01/14/25.
//

import Foundation

public protocol ExchangeRateRepository {
    func prepareRates(base: CurrencyType, to: [CurrencyType]) async throws
    func getRate(base: CurrencyType, to: CurrencyType) async -> Double?
}
