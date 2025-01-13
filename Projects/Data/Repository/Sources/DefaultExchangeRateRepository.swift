//
//  DefaultExchangeRateRepository.swift
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
    
    // DI
    @Injected private var priceService: ExchangeRateService
    
    // Cache
    private let exchangeRateCache: LockedDictionary<String, ExchangeRateVO> = .init()
    
    public init() { }
    
    public func prepare() -> AnyPublisher<Void, Error> {
        
        priceService.getExchanges(date: .now)
            .map { [weak self] priceDTO in
                let entities = priceDTO.map{ $0.toEntity() }
                entities.forEach { entity in
                    self?.exchangeRateCache[entity.currencyCode] = entity
                }
                return ()
            }
            .mapError({ error in
                printIfDebug("DefaultExchangeRateRepository, 환율정보 가져오기 실패, \(error.localizedDescription)")
                return ExchangeRateRepositoryError.fetchExhangeRateErrorError
            })
            .eraseToAnyPublisher()
    }
    
    public func getExchangeRateInKRW(currencyCode: String) -> AnyPublisher<ExchangeRateVO, Error> {
        
        Future { [weak self] promise in
            
            if let exchangeRate = self?.exchangeRateCache[currencyCode] {
                promise(.success(exchangeRate))
            } else {
                promise(.failure(ExchangeRateRepositoryError.exchangeRateNotFound))
            }
        }
        .eraseToAnyPublisher()
    }
}
