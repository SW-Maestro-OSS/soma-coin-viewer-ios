//
//  PriceRepository.swift
//  Domain
//
//  Created by 최재혁 on 12/22/24.
//

import Combine

public protocol PriceRepository {
    func requestPrice(date : String) -> AnyPublisher<PriceVO, Never>
}
