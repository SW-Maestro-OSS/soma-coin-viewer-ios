//
//  DefaultLocalizedStrProvider.swift
//  I18N
//
//  Created by choijunios on 5/14/25.
//

import DomainInterface

public final class DefaultLocalizedStrProvider: LocalizedStrProvider {
    // Dependency
    private let dataSource: LocalizedStringDataSource
    
    
    public init(dataSource: LocalizedStringDataSource) {
        self.dataSource = dataSource
    }
}


// MARK: LocalizedStrProvider
public extension DefaultLocalizedStrProvider {
    func getString(key: LocalizedStringKey, languageType: LanguageType) -> String {
        dataSource.getString(key: key.key, lanCode: languageType.lanCode) ?? "Unknown"
    }
}
