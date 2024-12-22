//
//  PriceVO.swift
//  Domain
//
//  Created by 최재혁 on 12/22/24.
//

import Foundation

public struct PriceVO {
    public let ttb : Double
    public let tts : Double
    
    public init(ttb: Double, tts: Double) {
        self.ttb = ttb
        self.tts = tts
    }
}
