//
//  PriceUseCase.swift
//  Domain
//
//  Created by 최재혁 on 12/24/24.
//

import Combine

public protocol PriceUseCase {
    func getPrice(currency : String) -> AnyPublisher<PriceVO, Never>
}
