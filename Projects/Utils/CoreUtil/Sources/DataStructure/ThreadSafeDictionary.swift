//
//  ThreadSafeDictionary.swift
//  CoreUtil
//
//  Created by choijunios on 4/22/25.
//

public actor ThreadSafeDictionary<Key, Value> where Key: Hashable {
    private var source: [Key: Value] = [:]
    
    public init() { }
    
    public var values: [Value] { Array(source.values) }
    public var keys: [Key] { Array(source.keys) }
    public subscript (_ key: Key) -> Value? {
        get { source[key] }
    }
    
    public func insert(key: Key, value: Value) {
        source[key] = value
    }
    
    public func remove(key: Key) {
        source.removeValue(forKey: key)
    }
}
