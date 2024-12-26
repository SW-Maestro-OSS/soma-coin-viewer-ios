//
//  Untitled.swift
//  I18N
//
//  Created by 최재혁 on 12/23/24.
//

import Foundation
import DomainInterface

public protocol I18NManager {
    //화페 타입 획득
    func getCurrencyType() -> CurrencyType
    
    //화페 타입 설정
    func setCurrencyType(type: CurrencyType)
    
    //언어 타입 획득
    func getLanguageType() -> LanguageType
    
    //언어 타입 설정
    func setLanguageType(type : LanguageType)
    
    //그리드 타입 획득
    func getGridType() -> GridType
    
    //그리드 타입 설정
    func setGridType(type : GridType)
    
    //환율 정보 획득
    func getExchangeRate(type : CurrencyType) -> PriceVO
    
    //환율 정보 외부 API로 부터 설정
    func setExchangeRate()
}
