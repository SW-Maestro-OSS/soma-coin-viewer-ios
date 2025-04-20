//
//  CVNumber.swift
//  CoreUtil
//
//  Created by choijunios on 12/6/24.
//

import Foundation

public struct CVNumber: Sendable, Hashable, Comparable, CustomStringConvertible, ExpressibleByFloatLiteral, Copyable {
    
    public typealias FloatLiteralType = Double
    
    public private(set) var wrappedNumber: Decimal
    
    public init(_ wrappedNumber: Double) {
        self.wrappedNumber = Decimal(wrappedNumber)
    }
    public init(_ wrappedNumber: Decimal) {
        self.wrappedNumber = wrappedNumber
    }
    public init?(_ integer: any BinaryInteger) {
        if let integer = Decimal(exactly: integer) {
            self.wrappedNumber = integer
        } else {
            return nil
        }
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
    
    public func roundDecimalPlaces(exact: Int) -> String {
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = exact
        formatter.minimumFractionDigits = exact
        formatter.roundingMode = .down

        let formattedString = formatter.string(from: wrappedNumber as NSDecimalNumber)
        
        return formattedString ?? "-1." + Array(repeating: "0", count: (exact-1))
    }
    
    public var description: String { wrappedNumber.description }
    public var double: Double { (wrappedNumber as NSDecimalNumber).doubleValue }
}

public extension CVNumber {
    static func + (lhs: Self, rhs: Self) -> Self {
        CVNumber(lhs.wrappedNumber + rhs.wrappedNumber)
    }
    
    static func < (lhs: CVNumber, rhs: CVNumber) -> Bool {
        lhs.wrappedNumber < rhs.wrappedNumber
    }
    
    static func / (lhs: CVNumber, rhs: CVNumber) -> CVNumber {
        CVNumber(lhs.wrappedNumber / rhs.wrappedNumber)
    }
}


// MARK: Copyable
public extension CVNumber {
    func copy() -> Any { self }
}
