//
//  FakeAllMarketTickerUseCase.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 4/24/25.
//

import Combine

import DomainInterface
import CoreUtil

public final class FakeAllMarketTickerUseCase: AllMarketTickersUseCase {
    
    public init() { }
    
    public func getTickerList(rowCount: UInt) -> AnyPublisher<[DomainInterface.Twenty4HourTickerForSymbolVO], Never> {
        let list = (0..<rowCount).map { index in
            var vo = Twenty4HourTickerForSymbolVO(
                pairSymbol: "BTC\(index)"+"USDT",
                price: CVNumber(Double(100 * index)),
                totalTradedQuoteAssetVolume: CVNumber(Double(100 * index)),
                changedPercent: CVNumber(Double(100 * index)),
                bestBidPrice: CVNumber(Double(100 * index)),
                bestAskPrice: CVNumber(Double(100 * index))
            )
            vo.setSymbols { pairSymbol in
                ("BTC\(index)", "USDT")
            }
            return vo
        }
        let publisher = CurrentValueSubject<[Twenty4HourTickerForSymbolVO], Never>(list)
        return publisher.eraseToAnyPublisher()
    }
    
    public func getTickerList(rowCount: UInt) async -> [DomainInterface.Twenty4HourTickerForSymbolVO] {
        (0..<rowCount).map { index in
            var vo = Twenty4HourTickerForSymbolVO(
                pairSymbol: "BTC\(index)"+"USDT",
                price: CVNumber(Double(100 * index)),
                totalTradedQuoteAssetVolume: CVNumber(Double(100 * index)),
                changedPercent: CVNumber(Double(100 * index)),
                bestBidPrice: CVNumber(Double(100 * index)),
                bestAskPrice: CVNumber(Double(100 * index))
            )
            vo.setSymbols { pairSymbol in
                ("BTC\(index)", "USDT")
            }
            return vo
        }
    }
    
    public func getExchangeRate(base: DomainInterface.CurrencyType, to: DomainInterface.CurrencyType) async -> Double? {
        1.0
    }
    
    public func getGridType() -> GridType { .list }
}
