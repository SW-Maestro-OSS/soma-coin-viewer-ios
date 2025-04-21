//
//  Type+Copyable.swift
//  CoreUtil
//
//  Created by choijunios on 4/21/25.
//

import Foundation

extension Date: @retroactive Copyable {
    public func copy() -> Any { self }
}

extension Int64: @retroactive Copyable {
    public func copy() -> Any { self }
}
