//
//  CoinTradeRepository.swift
//  Domain
//
//  Created by choijunios on 4/15/25.
//

import Combine
import Foundation

import CoreUtil

public protocol CoinTradeRepository {
    func getCoinTradeList(symbolPair: String, tableUpdateInterval: Double?) -> AnyPublisher<HashMap<Date, CoinTradeVO>, Never>
}
