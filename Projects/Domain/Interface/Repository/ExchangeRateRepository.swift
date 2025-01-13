//
//  PriceRepository.swift
//  Domain
//
//  Created by 최재혁 on 12/22/24.
//

import Foundation
import Combine

public enum ExchangeRateRepositoryError: LocalizedError {
    
    case fetchExhangeRateErrorError
    case exchangeRateNotFound
    
    public var errorDescription: String? {
        switch self {
        case .fetchExhangeRateErrorError:
            "환율정보를 가져올 수 없습니다."
        case .exchangeRateNotFound:
            "해당 통화의 환율정보를 확인할 수 없습니다."
        }
    }
}

public protocol ExchangeRateRepository {
    
    func prepare() -> AnyPublisher<Void, Error>
    
    func getExchangeRateInKRW(currencyCode: String) -> AnyPublisher<ExchangeRateVO, Error>
}
