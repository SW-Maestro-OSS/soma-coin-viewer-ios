//
//  AllMarketTickerRepository.swift
//  DomainInterface
//
//  Created by choijunios on 11/1/24.
//

import Foundation
import Combine

public protocol AllMarketTickerRepository {
    
    /// 24시간동안의 모든 심볼에대한 Ticker를 획득합니다.
    func connectToStream() -> AnyPublisher<[Symbol24hTickerVO], Never>
    
    /// 스트림을 종료합니다.
    func disConnectFromStream()
}
