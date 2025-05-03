//
//  ExchangeRateContainer.swift
//  Data
//
//  Created by choijunios on 4/22/25.
//

actor ExchangeRateContainer {
    private var store: [String: ExchangeRateDTO] = [:]
    
    func insert(base: String, dto: ExchangeRateDTO) { store[base] = dto }
    func get(base: String) -> ExchangeRateDTO? { store[base] }
}
