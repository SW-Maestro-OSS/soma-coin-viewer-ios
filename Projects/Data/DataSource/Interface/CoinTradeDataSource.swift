//
//  CoinTradeDataSource.swift
//  Data
//
//  Created by choijunios on 4/22/25.
//

import Combine

import CoreUtil

public protocol CoinTradeDataSource {
    func getTradeList(symbolPair: String, tableUpdateInterval: Double?) -> AnyPublisher<HashMap<Int64, BinanceCoinTradeDTO>, Never>
}
