//
//  LanguageType.swift
//  Domain
//
//  Created by choijunios on 1/13/25.
//

public enum LanguageType: String {
    //필요 언어 추가 가능
    case korean="KOR"
    case english="ENG"
    
    public var savingValue: String {
        self.rawValue
    }
}
