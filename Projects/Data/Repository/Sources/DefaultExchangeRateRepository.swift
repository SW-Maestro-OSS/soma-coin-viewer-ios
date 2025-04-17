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

import SwiftStructures

public class DefaultExchangeRateRepository: ExchangeRateRepository {
    // Dependency
    @Injected private var priceService: ExchangeRateService
    
    // Cache (base: [to: rate])
    private let exchangeRateCache: LockedDictionary<String, [String: Double]> = .init()
    
    public init() { }
    
    public func prepare(baseCurrencyCode: String, toCurrencyCodes: [String]) -> AnyPublisher<Void, Error> {
        
        priceService
            .getLatestExchangeRate(baseCurrencyCode: baseCurrencyCode, toCurrencyCodes: toCurrencyCodes)
            .map { [weak self] exchangeRateDTO in
                
                guard let self else { return () }
                
                exchangeRateCache[baseCurrencyCode] = [:]
                
                exchangeRateDTO.rates.forEach { symbol, rate in
                    
                    self.exchangeRateCache[baseCurrencyCode]?[symbol] = rate
                }
                
                return ()
            }
            .mapError({ error in
                printIfDebug("DefaultExchangeRateRepository, 환율정보 가져오기 실패, \(error.localizedDescription)")
                return ExchangeRateRepositoryError.fetchExhangeRateErrorError
            })
            .eraseToAnyPublisher()
    }
    
    public func getExchangeRate(baseCurrencyCode: String, toCurrencyCode: String) -> Double? {
        
        exchangeRateCache[baseCurrencyCode]?[toCurrencyCode]
    }
}
