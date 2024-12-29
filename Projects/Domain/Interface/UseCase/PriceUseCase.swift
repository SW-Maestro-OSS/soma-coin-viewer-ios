//
//  PriceUseCase.swift
//  Domain
//
//  Created by 최재혁 on 12/24/24.
//

import Combine

public protocol PriceUseCase {
    func getPrice(currency : String) -> PriceVO
    func setPrice() -> AnyPublisher<PriceState, Never>
}

public enum PriceState {
    case complete
    case ready
    case failed
}
