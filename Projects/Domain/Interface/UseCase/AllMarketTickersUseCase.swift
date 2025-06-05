//
//  AllMarketTickersUseCase.swift
//  Domain
//
//  Created by choijunios on 11/2/24.
//

import Combine

public protocol AllMarketTickersUseCase {
    /// 가격정보가 포함된 티커리스트를 획득합니다.
    func getTickerListStream(tickerCount: Int) -> AnyPublisher<TickerList, Never>
    
    /// 티커 표시방법에 대한 설정값을 획득합니다.
    func getGridType() -> GridType
}
