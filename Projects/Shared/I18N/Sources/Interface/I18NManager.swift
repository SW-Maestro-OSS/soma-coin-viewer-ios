//
//  I18NManager.swift
//  I18N
//
//  Created by 최재혁 on 12/23/24.
//

import Foundation
import DomainInterface
import Combine

public protocol I18NManager {
    
    //화페 타입 획득
    func getCurrencyType() -> CurrencyType
    
    //화페 타입 설정
    func setCurrencyType(type: CurrencyType)
    
    //언어 타입 획득
    func getLanguageType() -> LanguageType
    
    //언어 타입 설정
    func setLanguageType(type : LanguageType)
}
