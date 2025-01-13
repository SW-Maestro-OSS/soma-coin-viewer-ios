//
//  ExchangeRateUseCase.swift
//  Domain
//
//  Created by 최재혁 on 12/24/24.
//

import Combine

public protocol ExchangeRateUseCase {
    
    /// 원화 기준 환율정보를 반환 받습니다.
    func getExchangeRate(type: CurrencyType) -> AnyPublisher<ExchangeRateVO, Error>
    
    /// 가격 정보를 반환할 수 있도록 준비합니다.
    func prepare()
}
