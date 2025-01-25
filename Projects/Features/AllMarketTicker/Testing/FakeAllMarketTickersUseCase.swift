//
//  FakeAllMarketTickersUseCase.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/13/25.
//

import Foundation
import Combine

import DomainInterface

class FakeAllMarketTickersUseCase: AllMarketTickersUseCase {
    
    private var timer: Timer?
    private let fakeTickerPublisher = PassthroughSubject<[Twenty4HourTickerForSymbolVO], Never>()
    
    init() { }
    
    func prepareStream() {
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self else { return }
            let fakeTickers = createFakeTickers()
            fakeTickerPublisher.send(fakeTickers)
        }
    }
    
    func requestTickers() -> AnyPublisher<[DomainInterface.Twenty4HourTickerForSymbolVO], Never> {
        fakeTickerPublisher.eraseToAnyPublisher()
    }
    
    private func createFakeTickers() -> [Twenty4HourTickerForSymbolVO] {
        
        return (1...100).shuffled()[0..<30].map { index in
            return Twenty4HourTickerForSymbolVO(
                pairSymbol: "test\(index)USDT",
                price: .init(100.0 * Double.random(in: 1..<10)),
                totalTradedQuoteAssetVolume: .init(.random(in: 100..<2000)),
                changedPercent: .init(.random(in: -100...100))
            )
        }.map { vo in
            var newVO = vo
            newVO.setSymbols(closure: { pairSymbol in
                let firstSymbol = pairSymbol.replacingOccurrences(of: "USDT", with: "")
                let secondSymbol = "USDT"
                return (firstSymbol, secondSymbol)
            })
            return newVO
        }
    }
}
