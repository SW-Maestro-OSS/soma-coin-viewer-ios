//
//  UserConfigurationService.swift
//  DataSource
//
//  Created by choijunios on 10/15/24.
//

import Foundation

public protocol UserConfigurationService {
    
    /// Configuration정보를 획득합니다.
    func getConfiguration(key: String) -> String?
    
    
    /// Configuration정보를 설정합니다.
    func setConfiguration(key: String, value: String)
}

public class DefaultUserConfigurationService: UserConfigurationService {
    
    private let source: UserDefaults = .standard
    
    public func getConfiguration(key: String) -> String? {
        source.string(forKey: key)
    }
    
    public func setConfiguration(key: String, value: String) {
        source.set(value, forKey: key)
    }
}
