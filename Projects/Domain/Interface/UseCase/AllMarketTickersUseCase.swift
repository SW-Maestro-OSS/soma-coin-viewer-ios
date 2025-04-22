//
//  AllMarketTickersUseCase.swift
//  Domain
//
//  Created by choijunios on 11/2/24.
//

import Combine

public protocol AllMarketTickersUseCase {
    /// AllMarketTicker리스트를 획득합니다.
    func getTickerList() -> AnyPublisher<[Twenty4HourTickerForSymbolVO], Never>
    func getTickerList() async -> [Twenty4HourTickerForSymbolVO]
    
    
    /// 환율정보를 획득합니다.
    func getExchangeRate(base: CurrencyType, to: CurrencyType) async -> Double?
    
    
    /// GridType에 대한 유저설정을 획득합니다.
    func getGridType() -> GridType
}
