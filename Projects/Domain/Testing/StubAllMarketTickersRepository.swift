//
//  StubAllMarketTickersRepository.swift
//  Domain
//
//  Created by choijunios on 11/2/24.
//

import Combine
import Foundation

import DomainInterface
import CoreUtil

class StubAllMarketTickersRepository: AllMarketTickersRepository {
    
    let stubTickerEntities: [Twenty4HourTickerForSymbolVO]
    
    init(stubTickerEntities: [Twenty4HourTickerForSymbolVO]) {
        self.stubTickerEntities = stubTickerEntities
    }
    
    func request24hTickerForAllSymbols() -> AnyPublisher<[Twenty4HourTickerForSymbolVO], Never> {
        
        return Just(stubTickerEntities).eraseToAnyPublisher()
    }
}

