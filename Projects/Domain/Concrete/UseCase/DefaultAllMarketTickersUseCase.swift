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
    @Injected private var allMarketTickersRepository: AllMarketTickersRepository
    @Injected private var exchangeRateRepository: ExchangeRateRepository
    @Injected private var userConfigurationRepository: UserConfigurationRepository
    
    private let standardSymbol = "USDT"
    
    public init() { }
}


// MARK: AllMarketTickersUseCase, Stream
public extension DefaultAllMarketTickersUseCase {
    func getGridType() -> GridType { userConfigurationRepository.getGridType() }
    
    func getTickerList() async -> [Twenty4HourTickerForSymbolVO] {
        return []
    }
    
    func getTickerList() -> AnyPublisher<[Twenty4HourTickerForSymbolVO], Never> {
        allMarketTickersRepository
            .request24hTickerForAllSymbols()
            .throttle(for: 0.3, scheduler: DispatchQueue.global(qos: .default), latest: true)
            .map { [standardSymbol] fetchedTickers in
                
                // MARK: #1. Filter symbols that dont cotain Standard symbol as suffix
                
                fetchedTickers.filter { vo in
                    
                    let pairSymbol = vo.pairSymbol.uppercased()
                    
                    return pairSymbol.hasSuffix(standardSymbol)
                }
                
            }
            .map { [standardSymbol] standardTickers in
                
                // MARK: #2. Separate pair to each symbols
                
                standardTickers.map { ticker in
                    
                    var newTicker = ticker
                    
                    newTicker.setSymbols { pairSymbol in
                        
                        let upperScaled = pairSymbol.uppercased()
                        
                        let firstSymbol = upperScaled.replacingOccurrences(of: standardSymbol, with: "")
                        let secondSymbol = standardSymbol
                        
                        return (firstSymbol, secondSymbol)
                    }
                    
                    return newTicker
                }
            }
            .map { completedTickers in
                
                // MARK: #3. Sort tickers
                
                completedTickers.sorted { ticker1, ticker2 in
                    
                    ticker1.totalTradedQuoteAssetVolume > ticker2.totalTradedQuoteAssetVolume
                }
            }
            .map { sortedTickers in
                
                // MARK: #4. Cut 30 tickes
                
                let listSize = sortedTickers.count
                
                if listSize < 30 {
                    
                    return sortedTickers
                }
                
                return Array(sortedTickers[0..<30])
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
