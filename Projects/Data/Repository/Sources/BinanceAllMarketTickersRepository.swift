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
    
    public func getAllMarketTicker() -> AnyPublisher<AVLTree<Twenty4HourTickerForSymbolVO>, Never> {
        dataSource
            .getAllMarketTickerList()
            .unretained(self)
            .map { repo, dto in repo.convertToEntity(dto: dto) }
            .eraseToAnyPublisher()
    }
    
    public func getAllMarketTicker() async -> AVLTree<Twenty4HourTickerForSymbolVO> {
        let dto = await dataSource.getAllMarketTickerList()
        return convertToEntity(dto: dto)
    }
}
