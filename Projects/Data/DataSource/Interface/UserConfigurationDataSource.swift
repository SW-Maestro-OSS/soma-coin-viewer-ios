//
//  UserConfigurationDataSource.swift
//  Data
//
//  Created by choijunios on 5/4/25.
//

public protocol UserConfigurationDataSource {
    func getCurrency() -> String?
    func setCurrency(type: String)
    
    func getLanguageType() -> String?
    func setLanguageType(type: String)
    
    func getGridType() -> String?
    func setGridType(type: String)
}
