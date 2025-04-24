//
//  StubOrderbookRepository.swift
//  Domain
//
//  Created by choijunios on 4/24/25.
//

import Combine

import DomainInterface
import CoreUtil

public struct StubOrderbookRepository: OrderbookRepository {
    
    private let bidOrderbookCount: Int
    public var bidOrderbookSource: [(CVNumber, CVNumber)] {
        (0..<bidOrderbookCount).map { index in
            (CVNumber(index)!, CVNumber((0..<1000).randomElement()!)!)
        }
    }
    
    private let askOrderbookCount: Int
    public var askOrderbookSource: [(CVNumber, CVNumber)] {
        (0..<askOrderbookCount).map { index in
            (CVNumber(index)!, CVNumber((0..<1000).randomElement()!)!)
        }
    }
    
    public init(bidOrderbookCount: Int, askOrderbookCount: Int) {
        self.bidOrderbookCount = bidOrderbookCount
        self.askOrderbookCount = askOrderbookCount
    }
    
    
    public func getOrderbookTable(symbolPair: String) -> AnyPublisher<OrderbookTable, any Error> {
        let bidOrderbooks: HashMap<CVNumber, CVNumber> = .init()
        bidOrderbookSource.forEach { price, qty in
            bidOrderbooks[price] = qty
        }
        
        let askOrderbooks: HashMap<CVNumber, CVNumber> = .init()
        askOrderbookSource.forEach { price, qty in
            askOrderbooks[price] = qty
        }
        
        let table = OrderbookTable(
            bidOrderbooks: bidOrderbooks,
            askOrderbooks: askOrderbooks
        )
        let publisher = CurrentValueSubject<OrderbookTable, Error>(table)
        return publisher.eraseToAnyPublisher()
    }
}
