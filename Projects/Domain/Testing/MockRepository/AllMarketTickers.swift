//
//  AllMarketTickers.swift
//  Domain
//
//  Created by choijunios on 11/2/24.
//

import Combine
import Foundation

import DomainInterface

public class MockAllMarketTickersRepository: AllMarketTickerRepository {
    
    public init() { }
    
    public func subscribe() -> AnyPublisher<Array<Symbol24hTickerVO>, any Error> {
        
        let list = (0..<100).map { index in
            
            Symbol24hTickerVO(
                symbol: "test_symbol\(index)",
                price: 0.0,
                totalTradedQuoteAssetVolume: 100.0 * Double(index),
                changedPercent: 0.0
            )
        }
        
        let pub = CurrentValueSubject<[Symbol24hTickerVO], Error>(list)
        
        DispatchQueue.global().asyncAfter(deadline: .now()+1) {
            
            pub.send(completion: .finished)
        }
        
        return pub.eraseToAnyPublisher()
    }
    
    public func unsubscribe() {
        
    }
}
