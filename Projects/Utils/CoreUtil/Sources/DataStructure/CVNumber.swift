//
//  CVNumber.swift
//  CoreUtil
//
//  Created by choijunios on 12/6/24.
//

import Foundation

import AdvancedSwift

public struct CVNumber: Sendable, Hashable, Comparable, CustomStringConvertible, ExpressibleByFloatLiteral {
    
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
    
    public var description: String { wrappedNumber.description }
    public var double: Double { (wrappedNumber as NSDecimalNumber).doubleValue }
}


// MARK: Calc
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


// MARK: Rounded expression
public extension CVNumber {
    func roundToTwoDecimalPlaces() -> String {
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.roundingMode = .down

        let formattedString = formatter.string(from: wrappedNumber as NSDecimalNumber)
        
        return formattedString ?? "-1.0"
    }
    
    func roundDecimalPlaces(exact: Int) -> String {
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = exact
        formatter.minimumFractionDigits = exact
        formatter.roundingMode = .down

        let formattedString = formatter.string(from: wrappedNumber as NSDecimalNumber)
        
        return formattedString ?? "-1." + Array(repeating: "0", count: (exact-1))
    }
}


// MARK: Compact expression
public extension CVNumber {
    func formatCompactNumberWithSuffix() -> String {
        let thousand = Decimal(1_000)
        let million = Decimal(1_000_000)
        let billion = Decimal(1_000_000_000)
        let value = wrappedNumber
        
        var unit = ""
        var base = value

        switch value {
        case billion...:
            base = value / billion
            unit = "B"
        case million...:
            base = value / million
            unit = "M"
        case thousand...:
            base = value / thousand
            unit = "K"
        default:
            base = value
            unit = ""
        }

        for precision in (0...4).reversed() {
            let formatter = NumberFormatter()
            formatter.roundingMode = .down
            formatter.maximumFractionDigits = precision
            let minFraction = unit.isEmpty ? 4 : 3
            if minFraction > precision {
                formatter.minimumFractionDigits = precision
            } else {
                formatter.minimumFractionDigits = minFraction
            }
            formatter.numberStyle = .decimal
            
            if unit.isEmpty {
                // 1000미만 수인 경우
                if let numString = formatter.string(from: base as NSNumber),
                   numString.count <= 6 {
                    return "\(numString)\(unit)"
                }
            } else {
                if let numString = formatter.string(from: base as NSNumber),
                   numString.count <= 5 {
                    return "\(numString)\(unit)"
                }
            }
        }

        // 소수점 없애고 자른 뒤 리턴
        let maxSize = unit.isEmpty ? 6 : 5
        let slicedStr = "\(base.description.prefix(maxSize))"
        return "\(slicedStr)\(unit)"
    }
    
    func adaptiveFractionFormat(min: Int, max: Int) -> String {
        let formatter = NumberFormatter()
        formatter.roundingMode = .down
        formatter.minimumFractionDigits = min
        
        let base = double
        
        for fraction in min...max {
            formatter.maximumFractionDigits = fraction
            if let numString = formatter.string(from: base as NSNumber) {
                if numString.last == "0" { continue }
                else {
                    return numString
                }
            }
        }
        return roundDecimalPlaces(exact: max)
    }
}
