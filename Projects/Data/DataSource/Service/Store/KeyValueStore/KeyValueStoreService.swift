//
//  KeyValueStoreService.swift
//  DataSource
//
//  Created by choijunios on 10/15/24.
//

import Foundation

public protocol KeyValueStoreService {
    func fetch(key: String) -> Any?
    func save(key: String, value: Any)
}


public class DefaultKeyValueStoreService: KeyValueStoreService {
    // Dependency
    private let source: UserDefaults = .standard
    
    public init() { }
}


// MARK: KeyValueStoreService
public extension DefaultKeyValueStoreService {
    func fetch(key: String) -> Any? { source.object(forKey: key) }
    func save(key: String, value: Any) { source.set(value, forKey: key) }
}
