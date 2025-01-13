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

public class DefaultExchangeRateRepository : ExchangeRateRepository {
    // DI
    @Injected var priceService: PriceService
    
    public init() { }
    
    public func getPrice() -> AnyPublisher<[ExchangeRateVO], Never> {
        let date = self.getDate()
        return priceService.getPrice(date: date)
            .map { priceDTO in
                priceDTO.map{ $0.toEntity() }
            }
            .eraseToAnyPublisher()
    }
    
    private func getDate() -> String {
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: date)
    }
}
