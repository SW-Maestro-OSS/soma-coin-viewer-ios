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
    func getSingleTrade(symbolPair: String) -> AsyncStream<CoinTradeVO>
    func getCoinTradeList(symbolPair: String) -> AnyPublisher<HashMap<Date, CoinTradeVO>, Never>
}
