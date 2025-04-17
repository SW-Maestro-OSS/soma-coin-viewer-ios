//
//  AllMarketTickersUseCase.swift
//  Domain
//
//  Created by choijunios on 11/2/24.
//

import Combine

public protocol AllMarketTickersUseCase {
    
    /// AllMarketTicker스트림을 구독합니다.
    func connectToAllMarketTickerStream()
    
    /// 스트림 연결을 해제합니다.
    func disConnectToAllMarketTickerStream()
    
    /// AllMarketTicker리스트를 획득합니다.
    func requestTickers() -> AnyPublisher<[Twenty4HourTickerForSymbolVO], Never>
}
