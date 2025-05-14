//
//  SettingPageContents.swift
//  I18N
//
//  Created by choijunios on 5/14/25.
//

public enum SettingPageContents: String {
    case optionListCurrencyTitle
    case optionListCurrencySelectionTitle
    case optionListLanguageTitle
    case optionListLanguageSelectionTitle
    case optionListGridTypeTitle
    case optionListGridTypeSelectionTitle
    
    var keyPart: String { self.rawValue }
}
