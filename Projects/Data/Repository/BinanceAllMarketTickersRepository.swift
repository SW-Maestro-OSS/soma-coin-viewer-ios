//
//  BinanceAllMarketTickersRepository.swift
//  Repository
//
//  Created by choijunios on 11/1/24.
//

import Foundation
import Combine

import DataSource
import DomainInterface
import CoreUtil

public final class BinanceAllMarketTickersRepository: AllMarketTickersRepository {
    // Dependency
    @Injected private var dataSource: AllMarketTickersDataSource
    
    public init() { }
    
    private func convertToEntity(dto: [BinanceTickerForSymbolDTO]) -> AVLTree<Twenty4HourTickerForSymbolVO> {
        let treeEntity: AVLTree<Twenty4HourTickerForSymbolVO> = .init()
        for tickerDTO in dto {
            treeEntity.insert(tickerDTO.toEntity())
        }
        return treeEntity
    }
}


// MARK: AllMarketTickersRepository
public extension BinanceAllMarketTickersRepository {
    func getTickers() -> AnyPublisher<[Ticker], Never> {
        dataSource
            .getAllMarketTickerList()
            .map { tickerDTOs in
                tickerDTOs.map { dto in
                    // DTO를 엔티티로 변환
                    Ticker(
                        pairSymbol: dto.symbol,
                        price: Decimal(string: dto.lastPrice) ?? 0.0,
                        totalTradedQuoteAssetVolume: Decimal(string: dto.quoteAssetVolume) ?? 0.0,
                        changedPercent: Decimal(string: dto.priceChangePercent) ?? 0.0,
                        bestBidPrice: Decimal(string: dto.bestBidPrice) ?? 0.0,
                        bestAskPrice: Decimal(string: dto.bestAskPrice) ?? 0.0
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
