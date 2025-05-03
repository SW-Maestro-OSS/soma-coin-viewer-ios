//
//  AllMarketTickersDataSource.swift
//  Data
//
//  Created by choijunios on 4/22/25.
//

import Combine

public protocol AllMarketTickersDataSource {
    func getAllMarketTickerList() -> AnyPublisher<[BinanceTickerForSymbolDTO], Never>
    func getAllMarketTickerList() async -> [BinanceTickerForSymbolDTO]
}


