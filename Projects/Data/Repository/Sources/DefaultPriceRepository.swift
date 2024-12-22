//
//  DefaultPriceRepository.swift
//  Data
//
//  Created by 최재혁 on 12/22/24.
//

import Foundation

import DataSource
import DomainInterface
import Combine
import CoreUtil

public class DefaultPriceRepository : PriceRepository {
    // DI
    @Injected var priceService: PriceService
    
    public init() { }
    
    public func requestPrice(date : String) -> AnyPublisher<PriceVO, Never> {
        return priceService.getDollarPrice(date: "")
            .map { $0.toEntity() }
            .eraseToAnyPublisher()
    }
}
