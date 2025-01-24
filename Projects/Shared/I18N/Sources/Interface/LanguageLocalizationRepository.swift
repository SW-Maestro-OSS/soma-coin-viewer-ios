//
//  LanguageLocalizationRepository.swift
//  I18N
//
//  Created by choijunios on 1/23/25.
//

public protocol LanguageLocalizationRepository {
    
    func getString(key: String, lanCode: String) -> String
}
