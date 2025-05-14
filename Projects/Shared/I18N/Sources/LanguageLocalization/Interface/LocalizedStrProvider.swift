//
//  LocalizedStrProvider.swift
//  I18N
//
//  Created by choijunios on 5/14/25.
//

import DomainInterface

public protocol LocalizedStrProvider {
    func getString(key: LocalizedStringKey, languageType: LanguageType) -> String
}
