//
//  ExchangeRateDTO.swift
//  Data
//
//  Created by choijunios on 1/13/25.
//

public struct ExchangeRateDTO: Decodable {
    
    public let base: String
    public let rates: [String: Double]
}
