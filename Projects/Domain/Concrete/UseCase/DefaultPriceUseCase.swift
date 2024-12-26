//
//  DefaultPriceUseCase.swift
//  Domain
//
//  Created by 최재혁 on 12/24/24.
//

import Foundation
import Combine

import DomainInterface
import CoreUtil

public class DefaultPriceUseCase : PriceUseCase {
    
    @Injected private var repository: PriceRepository
    
    public init() { }
    
    public func getPrice(currency: String) -> AnyPublisher<PriceVO, Never> {
        return repository.getPrice()
            .map { priceVO in
                let filteredPriceVO = priceVO.filter { $0.currencyCode == currency}
                return filteredPriceVO.first ?? PriceVO(currencyCode: "ErrorPrice", ttb: -1, tts: -1)
            }
            .eraseToAnyPublisher()
    }
}
