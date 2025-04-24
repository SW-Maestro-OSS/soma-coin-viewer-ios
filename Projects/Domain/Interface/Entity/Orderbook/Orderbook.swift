//
//  Orderbook.swift
//  Domain
//
//  Created by choijunios on 4/21/25.
//

import CoreUtil

public struct Orderbook: Sendable, Equatable {
    public let price: CVNumber
    public let quantity: CVNumber
    public init(price: CVNumber, quantity: CVNumber) {
        self.price = price
        self.quantity = quantity
    }
}
