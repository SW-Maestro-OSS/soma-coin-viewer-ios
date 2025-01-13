//
//  PriceVO.swift
//  Domain
//
//  Created by 최재혁 on 12/22/24.
//

import Foundation

public struct ExchangeRateVO {
    public let currencyCode : String
    public let ttb : Double
    public let tts : Double
    
    public init(currencyCode: String ,ttb: Double, tts: Double) {
        self.currencyCode = currencyCode
        self.ttb = ttb
        self.tts = tts
    }
}
