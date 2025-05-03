//
//  LockedDictionary.swift
//  Data
//
//  Created by choijunios on 4/22/25.
//

import Foundation

public class LockedDictionary<Key, Value> where Key: Hashable {
    
    typealias Source = Dictionary<Key, Value>
    
    private var source: Source = [:]
    
    private let queue = DispatchQueue(
        label: "com.lockeddictionary.concurrentQueue",
        attributes: .concurrent
    )
    
    public init() { }
    
    public var values: [Value] {
        queue.sync { source.values.map({ $0 }) }
    }
    
    public var keys: [Key] {
        queue.sync { source.keys.map({ $0 }) }
    }
    
    public subscript(key: Key) -> Value? {
        get {
            queue.sync { source[key] }
        }
        set(newValue) {
            queue.async(flags: .barrier) { [weak self] in
                self?.source[key] = newValue
            }
        }
    }
    
    public func remove(key: Key) {
        queue.async(flags: .barrier) { [weak self] in
            self?.source.removeValue(forKey: key)
        }
    }
}
