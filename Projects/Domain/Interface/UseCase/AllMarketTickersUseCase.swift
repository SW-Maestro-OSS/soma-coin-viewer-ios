//
//  AllMarketTickersUseCase.swift
//  Domain
//
//  Created by choijunios on 11/2/24.
//

import Combine

public protocol AllMarketTickersUseCase {
    /// AllMarketTicker리스트를 획득합니다.
    func getTickerList(rowCount: UInt) -> AnyPublisher<[Twenty4HourTickerForSymbolVO], Never>
    func getTickerList(rowCount: UInt) async -> [Twenty4HourTickerForSymbolVO]
    
    func getTickerListStream(tickerCount: Int) -> AnyPublisher<TickerList, Never>
    
    
    /// 환율정보를 획득합니다.
    func getExchangeRate(base: CurrencyType, to: CurrencyType) async -> Double?
    
    
    /// GridType에 대한 유저설정을 획득합니다.
    func getGridType() -> GridType
}
