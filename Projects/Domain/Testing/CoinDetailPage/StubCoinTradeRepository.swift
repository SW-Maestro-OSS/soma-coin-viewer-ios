//
//  StubCoinTradeRepository.swift
//  Domain
//
//  Created by choijunios on 4/24/25.
//

import Foundation
import Combine

import DomainInterface
import CoreUtil

public struct StubCoinTradeRepository: CoinTradeRepository {
    
    public init() { }
    
    public func getCoinTradeList(symbolPair: String, tableUpdateInterval: Double?) -> AnyPublisher<HashMap<Date, CoinTradeVO>, Never> {
        let hashMap = HashMap<Date, CoinTradeVO>()
        return Just(hashMap).eraseToAnyPublisher()
    }
}
