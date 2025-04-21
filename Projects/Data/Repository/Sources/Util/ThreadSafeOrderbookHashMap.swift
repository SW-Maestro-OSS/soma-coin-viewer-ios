//
//  ThreadSafeOrderbookHashMap.swift
//  Data
//
//  Created by choijunios on 4/21/25.
//

import CoreUtil

actor ThreadSafeOrderbookHashMap {
    let hashMap: HashMap<CVNumber, CVNumber> = .init()
    
    subscript (_ key: CVNumber) -> CVNumber? {
        get { hashMap[key] }
    }
    
    func insert(key: CVNumber, value: CVNumber) {
        hashMap[key] = value
    }
    
    func removeValue(_ forKey: CVNumber) {
        hashMap.removeValue(forKey)
    }
}
