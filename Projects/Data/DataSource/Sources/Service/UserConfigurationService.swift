//
//  UserConfigurationService.swift
//  DataSource
//
//  Created by choijunios on 10/15/24.
//

import Foundation

public protocol UserConfigurationService {
    
    /// Configuration정보를 획득합니다.
    func getConfiguration(key: String) -> String
    
    
    /// Configuration정보를 설정합니다.
    func setConfiguration(key: String, value: String) -> String
}
