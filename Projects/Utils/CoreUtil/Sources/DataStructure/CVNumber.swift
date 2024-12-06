//
//  CVNumber.swift
//  CoreUtil
//
//  Created by choijunios on 12/6/24.
//

import Foundation

public struct CVNumber: Comparable {
    
    private var wrappedNumber: Decimal
    
    public init(_ wrappedNumber: Double) {
        
        self.wrappedNumber = Decimal(wrappedNumber)
    }
    
    public func roundToTwoDecimalPlaces() -> Decimal {
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.roundingMode = .down

        let formattedString = formatter.string(from: wrappedNumber as NSDecimalNumber)
        
        return Decimal(string: formattedString ?? "-1.0") ?? -1.0
    }
    
    public static func < (lhs: CVNumber, rhs: CVNumber) -> Bool {
        
        lhs.wrappedNumber < rhs.wrappedNumber
    }
}
