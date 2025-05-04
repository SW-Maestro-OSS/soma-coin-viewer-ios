//
//  KeyValueStoreService.swift
//  DataSource
//
//  Created by choijunios on 10/15/24.
//

import Foundation

public protocol KeyValueStoreService {
    func fetchString(key: String) -> String?
    func saveString(key: String, value: String)
}


public class DefaultKeyValueStoreService: KeyValueStoreService {
    // Dependency
    private let source: UserDefaults = .standard
    
    public init() { }
}


// MARK: KeyValueStoreService
public extension DefaultKeyValueStoreService {
    func fetchString(key: String) -> String? {
        source.string(forKey: key)
    }
    func saveString(key: String, value: String) {
        source.set(value, forKey: key)
    }
}
