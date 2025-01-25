//
//  asd.swift
//  I18N
//
//  Created by choijunios on 1/14/25.
//

import SwiftUI

import DomainInterface
import CoreUtil

public struct LocalizableText: View {
    
    // Service locator
    @Injected private var repository: LanguageLocalizationRepository
    
    private let key: String
    @Binding var languageType: LanguageType
    
    public init(key: String, languageType: Binding<LanguageType>) {
        self.key = key
        self._languageType = languageType
    }
    
    public var body: some View {
        
        Text(repository.getString(key: key, lanCode: languageType.lanCode))
    }
}

