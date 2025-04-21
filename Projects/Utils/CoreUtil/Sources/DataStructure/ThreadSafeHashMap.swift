//
//  ThreadSafeHashMap.swift
//  CoreUtil
//
//  Created by choijunios on 4/21/25.
//

public actor ThreadSafeHashMap<Key: Copyable & Comparable & Hashable, Value> {
    public let hashMap: HashMap<Key, Value> = .init()
    
    public init() { }
    
    public subscript (_ key: Key) -> Value? {
        get { hashMap[key] }
    }
    
    public func insert(key: Key, value: Value) {
        hashMap[key] = value
    }
    
    public func removeValue(_ forKey: Key) {
        hashMap.removeValue(forKey)
    }
    
    public func removeAll() { hashMap.clear() }
}
