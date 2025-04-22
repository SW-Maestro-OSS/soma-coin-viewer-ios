//
//  ExchangeRateDataSource.swift
//  Data
//
//  Created by choijunios on 4/22/25.
//

public protocol ExchangeRateDataSource {
    func prepareRates(base: String, to: [String]) async throws
    func getExchangeRate(base: String) async -> ExchangeRateDTO?
}
