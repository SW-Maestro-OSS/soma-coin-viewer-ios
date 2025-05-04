//
//  DefaultUserConfigurationDataSource.swift
//  Data
//
//  Created by choijunios on 5/4/25.
//

import CoreUtil

final public class DefaultUserConfigurationDataSource: UserConfigurationDataSource {
    // Dependency
    @Injected private var service: KeyValueStoreService
    
    // State
    private let memoryCache: LockedDictionary<String, Any> = .init()
    
    // Keys
    private let currencySavingKey = "configuration_currency"
    private let languageSavingKey = "configuration_language"
    private let gridTypeSavingKey = "configuration_gridType"
    
    
    public init() { }
    

    private func checkMemCache<T>(key: String) -> T? { memoryCache[key] as? T }
    private func cacheToMemory(key: String, value: Any) { memoryCache[key] = value }
    private func fetch(key: String) -> Any? {
        if let memoryCache: String = checkMemCache(key: key) {
            // 매모리 캐쉬가 존재하는 경우
            return memoryCache
        }
        if let storeData = service.fetch(key: key) {
            // 로컬에 저장된 정보가 있는 경우
            defer { cacheToMemory(key: key, value: storeData) }
            return storeData
        }
        return nil
    }
    private func save(key: String, value: Any) {
        service.save(key: key, value: value)
        cacheToMemory(key: key, value: value)
    }
}


// MARK: UserConfigurationDataSource
public extension DefaultUserConfigurationDataSource {
    func getCurrency() -> String? { fetch(key: currencySavingKey) as? String }
    func setCurrency(type: String) { save(key: currencySavingKey, value: type) }
    
    func getLanguageType() -> String? { fetch(key: languageSavingKey) as? String }
    func setLanguageType(type: String) { save(key: languageSavingKey, value: type) }
    
    func getGridType() -> String? { fetch(key: gridTypeSavingKey) as? String }
    func setGridType(type: String) { save(key: gridTypeSavingKey, value: type) }
}
