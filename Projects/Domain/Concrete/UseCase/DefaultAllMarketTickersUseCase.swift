//
//  DefaultAllMarketTickersUseCase.swift
//  Domain
//
//  Created by choijunios on 11/2/24.
//

import Foundation
import Combine

import DomainInterface
import CoreUtil

public final class DefaultAllMarketTickersUseCase: AllMarketTickersUseCase {
    // Dependency
    private var allMarketTickersRepository: AllMarketTickersRepository
    private var exchangeRateRepository: ExchangeRateRepository
    private var userConfigurationRepository: UserConfigurationRepository
    
    private let standardSymbol = "USDT"
    
    public init(
        allMarketTickersRepository: AllMarketTickersRepository,
        exchangeRateRepository: ExchangeRateRepository,
        userConfigurationRepository: UserConfigurationRepository
    ) {
        self.allMarketTickersRepository = allMarketTickersRepository
        self.exchangeRateRepository = exchangeRateRepository
        self.userConfigurationRepository = userConfigurationRepository
    }
    
    // 도메인 로직
    private func fetchGreatestQuantity(entity: AVLTree<Twenty4HourTickerForSymbolVO>, maxCount: UInt) -> [Twenty4HourTickerForSymbolVO] {
        // 내림차순 정렬 및 기준 심볼을 포함한 심볼만 추출
        let filteredEntity = entity.getDiscendingList(maxCount: .max)
            .filter({ $0.pairSymbol.uppercased().hasSuffix(standardSymbol) })
        let slicedEntity = filteredEntity.prefix(Int(maxCount))
        
        // 기준 심볼을 기준으로 pairSymbol을 양분화
        let symbolSeparated = slicedEntity.map { tickerEntity in
            var newTicker = tickerEntity
            newTicker.setSymbols { pairSymbol in
                let upperScaled = pairSymbol.uppercased()
                let firstSymbol = upperScaled.replacingOccurrences(of: standardSymbol, with: "")
                let secondSymbol = standardSymbol
                return (firstSymbol, secondSymbol)
            }
            return newTicker
        }
        return symbolSeparated
    }
}


// MARK: AllMarketTickersUseCase, Stream
public extension DefaultAllMarketTickersUseCase {
    func getGridType() -> GridType {
        userConfigurationRepository.getGridType() ?? .defaultValue
    }
    
    func getTickerList(rowCount: UInt) async -> [Twenty4HourTickerForSymbolVO] {
        let entity = await allMarketTickersRepository.getAllMarketTicker()
        return fetchGreatestQuantity(entity: entity, maxCount: rowCount)
    }
    
    func getTickerList(rowCount: UInt) -> AnyPublisher<[Twenty4HourTickerForSymbolVO], Never> {
        allMarketTickersRepository
            .getAllMarketTicker()
            .unretained(self)
            .map { useCase, entity in
                useCase.fetchGreatestQuantity(entity: entity, maxCount: rowCount)
            }
            .eraseToAnyPublisher()
    }
}


// MARK: AllMarketTickersUseCase, exchange rate
public extension DefaultAllMarketTickersUseCase {
    func getExchangeRate(base: CurrencyType, to: CurrencyType) async -> Double? {
        await exchangeRateRepository.getRate(base: base, to: to)
    }
}
