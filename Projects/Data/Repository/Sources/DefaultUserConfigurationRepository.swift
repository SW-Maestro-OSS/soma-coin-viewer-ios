//
//  DefaultUserConfigurationRepository.swift
//  Repository
//
//  Created by choijunios on 10/15/24.
//

import Foundation
import DataSource
import Domain
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
        
        if let diskCached = userConfigurationService.getConfiguration(key: config.savingKey) {
            // 로컬에 저장된 정보를 확인합니다.
            
            // 정보를 메모리에 캐싱
            cachedConfiguration[config.savingKey] = diskCached
            
            return .init(rawValue: diskCached)!
        }
        
        return .init(rawValue: config.defaultSavingValue)!
    }
    
    
    
    public func setCurrencyType(type: Domain.CurrencyType) {
        let config: UserConfiguration = .currency
        
        // 디스크 저장
        userConfigurationService.setConfiguration(key: config.savingKey, value: type.savingValue)
        
        // 메모리 저장
        cachedConfiguration[config.savingKey] = type.savingValue
    }
    
    
    
    public func getGridType() -> Domain.GridType {
        let config: UserConfiguration = .gridType
        
        if let memoryCached: String = checkMemoryCache(key: config.savingKey) {
            // 캐싱된 정보를 먼저 확인합니다.
            return .init(rawValue: memoryCached)!
        }
        
        if let diskCached = userConfigurationService.getConfiguration(key: config.savingKey) {
            // 로컬에 저장된 정보를 확인합니다.
            
            // 정보를 메모리에 캐싱
            cachedConfiguration[config.savingKey] = diskCached
            
            return .init(rawValue: diskCached)!
        }
        
        return .init(rawValue: config.defaultSavingValue)!
    }
    
    
    
    public func setGrideType(type: Domain.GridType) {
        let config: UserConfiguration = .gridType
        
        // 디스크 저장
        userConfigurationService.setConfiguration(key: config.savingKey, value: type.savingValue)
        
        // 메모리 저장
        cachedConfiguration[config.savingKey] = type.savingValue
    }
    
    
    
    // MARK: check cache
    private func checkMemoryCache<T>(key: String) -> T? {
        if Thread.isMainThread {
            printIfDebug("메인쓰레드에서 LockedDictionary에 접근하고 있다, 해당동작은 메인쓰레드를 블로킹(NSLock)할 수 있다.")
        }
        return cachedConfiguration[key] as? T
    }
}
