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

import SwiftStructures

public class DefaultPriceUseCase : PriceUseCase {
    
    @Injected private var repository: PriceRepository
    
    // Cache configuration
    private let cachedConfiguration: LockedDictionary<String, Any> = .init()
    
    public init() { }
    
    public func getPrice(currency: String) -> PriceVO {
        if let cachedPrices = getCachedPriceVOList(key: "currencyPrices"),
                   let cachedPrice = cachedPrices.first(where: { $0.currencyCode == currency }) {
            return cachedPrice
        }
                
        return PriceVO(currencyCode: "ErrorPrice", ttb: -1, tts: -1)
    }
    
    public func setPrice() -> AnyPublisher<PriceState, Never> {
        repository.getPrice()
            .map { priceVOList in
                if priceVOList.isEmpty {
                    return .failed
                } else {
                    self.caching(key: "currencyPrices", value: priceVOList)
                    return .complete
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: check cache
    private func checkMemoryCache<T>(key: String) -> T? {
        cachedConfiguration[key] as? T
    }
    
    private func caching(key: String, value: Any) {
        
        DispatchQueue.global().async { [weak self] in
            // 정보를 메모리에 캐싱
            self?.cachedConfiguration[key] = value
        }
    }
    
    private func getCachedPriceVOList(key: String) -> [PriceVO]? {
        cachedConfiguration[key] as? [PriceVO]
    }
}
