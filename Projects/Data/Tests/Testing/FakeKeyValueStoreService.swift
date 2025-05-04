//
//  FakeKeyValueStoreService.swift
//  Data
//
//  Created by choijunios on 5/4/25.
//

import DataSource

final class FakeKeyValueStoreService: KeyValueStoreService {
    
    private var fakeDB: [String: Any] = [:]
    
    func fetch(key: String) -> Any? {
        fakeDB[key]
    }
    
    func save(key: String, value: Any) {
        fakeDB[key] = value
    }
}
