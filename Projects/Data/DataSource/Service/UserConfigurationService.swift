//
//  UserConfigurationService.swift
//  DataSource
//
//  Created by choijunios on 10/15/24.
//

import Foundation

public protocol UserConfigurationService {
    
    /// Configuration정보를 획득합니다.
    func getStringValue(key: String) -> String?
    
    
    /// Configuration정보를 설정합니다.
    func setConfiguration<T>(key: String, value: T)
}

public class DefaultUserConfigurationService: UserConfigurationService {
    
    private let source: UserDefaults = .standard
    
    public init() { }
    
    public func getStringValue(key: String) -> String? {
        source.string(forKey: key)
    }
    
    public func setConfiguration<T>(key: String, value: T) {
        source.set(value, forKey: key)
    }
}
