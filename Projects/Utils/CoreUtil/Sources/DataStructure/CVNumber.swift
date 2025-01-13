//
//  CVNumber.swift
//  CoreUtil
//
//  Created by choijunios on 12/6/24.
//

import Foundation

public struct CVNumber: Comparable, CustomStringConvertible, ExpressibleByFloatLiteral {
    
    public typealias FloatLiteralType = Double
    
    
    public private(set) var wrappedNumber: Decimal
    
    public init(_ wrappedNumber: Double) {
        self.wrappedNumber = Decimal(wrappedNumber)
    }
    public init(_ wrappedNumber: Decimal) {
        self.wrappedNumber = wrappedNumber
    }
    public init(floatLiteral value: Double) {
        self.wrappedNumber = Decimal(value)
    }
    
    public func roundToTwoDecimalPlaces() -> String {
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.roundingMode = .down

        let formattedString = formatter.string(from: wrappedNumber as NSDecimalNumber)
        
        return formattedString ?? "-1.0"
    }
}

extension CVNumber {
    
    public static func < (lhs: CVNumber, rhs: CVNumber) -> Bool {
        
        lhs.wrappedNumber < rhs.wrappedNumber
    }
}

extension CVNumber {
    
    public var description: String {
        
        wrappedNumber.description
    }
}
