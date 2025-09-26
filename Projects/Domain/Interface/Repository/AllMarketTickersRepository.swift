//
//  AllMarketTickersRepository.swift
//  Domain
//
//  Created by choijunios on 11/11/24.
//

import Combine

import CoreUtil

public protocol AllMarketTickersRepository {
    func getStream(baseSymbol: String) -> AnyPublisher<[Ticker], Never>
}
