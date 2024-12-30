//
//  MockPriceRepository.swift
//  Domain
//
//  Created by 최재혁 on 12/24/24.
//

import Combine
import Foundation

import DomainInterface
import CoreUtil

public class MockPriceRepository: PriceRepository {
    
    public init() { }
    
    public func getPrice() -> AnyPublisher<[PriceVO], Never> {
        return Just(MockPriceRepository.createMockData()).eraseToAnyPublisher()
    }
}

fileprivate extension MockPriceRepository {
    
    static func createMockData() -> [PriceVO] {
        [
            PriceVO(currencyCode: "Mock1", ttb: 1.0, tts: 1.0),
            PriceVO(currencyCode: "Mock2", ttb: 2.0, tts: 2.0),
            PriceVO(currencyCode: "Mock3", ttb: 3.0, tts: 3.0),
            PriceVO(currencyCode: "Mock4", ttb: 4.0, tts: 4.0),
            PriceVO(currencyCode: "Mock5", ttb: 5.0, tts: 5.0)
        ]
    }
}
