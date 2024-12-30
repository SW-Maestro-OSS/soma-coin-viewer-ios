//
//  PriceUsecaseTests.swift
//  Domain
//
//  Created by 최재혁 on 12/24/24.
//

import Testing
import Foundation
import Combine

import Domain
import DomainInterface
import CoreUtil

import DomainTesting

struct PriceUsecaseTests {
    
    let priceUsecase : DefaultPriceUseCase
    var cancellables : Set<AnyCancellable> = []
    
    init() {
        DependencyInjector.shared.register(PriceRepository.self, MockPriceRepository())
        
        self.priceUsecase = .init()
    }
    
    @Test
    mutating func getPriceDataTest() {
        let expectData = "Mock3"
        let testData = priceUsecase.getPrice(currency: "Mock3").first()
        
        testData
            .sink { price in
                #expect(price.currencyCode == expectData)
            }
            .store(in: &cancellables)
    }
}
