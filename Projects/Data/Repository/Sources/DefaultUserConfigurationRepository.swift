//
//  DefaultUserConfigurationRepository.swift
//  Repository
//
//  Created by choijunios on 10/15/24.
//

import Foundation

import DataSource
import DomainInterface
import CoreUtil


import SwiftStructures

public class DefaultUserConfigurationRepository: UserConfigurationRepository {
    
    // DI
    @Injected var userConfigurationService: UserConfigurationService
    
    // Cache configuration
    private let cachedConfiguration: LockedDictionary<String, Any> = .init()
    
    public init() { }
    
    public func getCurrencyType() -> CurrencyType {
        let config: UserConfiguration = .currency
        
        if let memoryCached: String = checkMemoryCache(key: config.savingKey) {
            // 캐싱된 정보를 먼저 확인합니다.
            return .init(rawValue: memoryCached)!
        }
        
        if let diskCached = userConfigurationService.getStringValue(key: config.savingKey) {
            // 로컬에 저장된 정보를 확인합니다.
            
            // 정보를 메모리에 캐싱
            caching(key: config.savingKey, value: diskCached)
            
            return .init(rawValue: diskCached)!
        }
        
        return .init(rawValue: config.defaultSavingValue)!
    }
    
    
    
    public func setCurrencyType(type: CurrencyType) {
        let config: UserConfiguration = .currency
        
        // 디스크 저장
        userConfigurationService.setConfiguration(key: config.savingKey, value: type.savingValue)
        
        // 정보를 메모리에 캐싱
        caching(key: config.savingKey, value: type.savingValue)
    }
    
    
    
    public func getGridType() -> GridType {
        let config: UserConfiguration = .gridType
        
        if let memoryCached: String = checkMemoryCache(key: config.savingKey) {
            // 캐싱된 정보를 먼저 확인합니다.
            return .init(rawValue: memoryCached)!
        }
        
        if let diskCached = userConfigurationService.getStringValue(key: config.savingKey) {
            // 로컬에 저장된 정보를 확인합니다.
            
            // 정보를 메모리에 캐싱
            caching(key: config.savingKey, value: diskCached)
            
            return .init(rawValue: diskCached)!
        }
        
        return .init(rawValue: config.defaultSavingValue)!
    }
    
    
    
    public func setGrideType(type: GridType) {
        let config: UserConfiguration = .gridType
        
        // 디스크 저장
        userConfigurationService.setConfiguration(key: config.savingKey, value: type.savingValue)
        
        // 메모리 저장
        cachedConfiguration[config.savingKey] = type.savingValue
    }
    
    
    // MARK: check cache
    private func checkMemoryCache<T>(key: String) -> T? {
        cachedConfiguration[key] as? T
    }
    
    private func caching(key: String, value: Any) {
        
        DispatchQueue.global().async { [weak self] in
            // 정보를 메모리에 캐싱
            self?.cachedConfiguration[key] = value
        }
    }
}
