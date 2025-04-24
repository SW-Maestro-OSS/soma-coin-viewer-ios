//
//  StubAllMaketTickerRepository.swift
//  Domain
//
//  Created by choijunios on 4/24/25.
//

import Combine

import DomainInterface
import CoreUtil

public struct StubAllMaketTickerRepository: AllMarketTickersRepository {
    
    public let maxTickerCount: Int
    public let usdtSuffixCount: Int
    
    public init(maxTickerCount: Int, usdtSuffixCount: Int) {
        self.maxTickerCount = maxTickerCount
        self.usdtSuffixCount = usdtSuffixCount
    }
    
    private func createFakeData() -> AVLTree<Twenty4HourTickerForSymbolVO> {
        let tree = AVLTree<Twenty4HourTickerForSymbolVO>()
        for index in 0..<maxTickerCount {
            let vo = Twenty4HourTickerForSymbolVO(
                pairSymbol: index < usdtSuffixCount ? "BTCUSDT" : "BTCADA",
                price: CVNumber(Double(100 * index)),
                totalTradedQuoteAssetVolume: CVNumber(Double(100 * index)),
                changedPercent: CVNumber(Double(100 * index)),
                bestBidPrice: CVNumber(Double(100 * index)),
                bestAskPrice: CVNumber(Double(100 * index))
            )
            tree.insert(vo)
        }
        return tree
    }
    
    public func getAllMarketTicker() -> AnyPublisher<AVLTree<Twenty4HourTickerForSymbolVO>, Never> {
        return Just(createFakeData()).eraseToAnyPublisher()
    }
    
    public func getAllMarketTicker() async -> AVLTree<Twenty4HourTickerForSymbolVO> {
        return createFakeData()
    }
}
