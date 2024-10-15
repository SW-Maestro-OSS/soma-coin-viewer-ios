//
//  UserConfigurationRepository.swift
//  Domain
//
//  Created by choijunios on 10/15/24.
//

import Foundation

public protocol UserConfigurationRepository {
    
    /// 화폐 타입을 획득합니다.
    func getCurrencyType() -> CurrencyType
    
    /// 화폐 타입을 설정합니다.
    func setCurrencyType(type: CurrencyType)
    
    /// 그리드 타입을 획득합니다.
    func getGridType() -> GridType
    
    /// 그리드 타입을 설정합니다.
    func setGrideType(type: GridType)
}
