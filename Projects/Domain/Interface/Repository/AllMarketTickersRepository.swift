//
//  AllMarketTickersRepository.swift
//  Domain
//
//  Created by choijunios on 11/11/24.
//

import Combine

import CoreUtil

public protocol AllMarketTickersRepository {
    func getTickers() -> AnyPublisher<[Ticker], Never>
    
    
    func getAllMarketTicker() -> AnyPublisher<AVLTree<Twenty4HourTickerForSymbolVO>, Never>
    func getAllMarketTicker() async -> AVLTree<Twenty4HourTickerForSymbolVO>
}
