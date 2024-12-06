//
//  AllMarketTickers.swift
//  Domain
//
//  Created by choijunios on 11/2/24.
//

import Combine
import Foundation

import DomainInterface
import CoreUtil

public class MockAllMarketTickersRepository: AllMarketTickersRepository {
    
    public init() { }
    
    public func request24hTickerForAllSymbols() -> AnyPublisher<[Twenty4HourTickerForSymbolVO], Never> {
        
        let list = (0..<100).shuffled().map { index in
            
            Twenty4HourTickerForSymbolVO.createMock(index: index)
        }
        
        return Just(list).eraseToAnyPublisher()
    }
}

fileprivate extension Twenty4HourTickerForSymbolVO {
    
    static func createMock(index: Int) -> Twenty4HourTickerForSymbolVO {
        
        Twenty4HourTickerForSymbolVO(
            symbol: "symbol\(index)",
            price: CVNumber(100.0 * Double(index)),
            totalTradedQuoteAssetVolume: 100.0 * Double(index),
            changedPercent: Double(index % 100)
        )
    }
}

