//
//  asd.swift
//  I18N
//
//  Created by choijunios on 1/14/25.
//

import SwiftUI

import DomainInterface
import CoreUtil

import I18N

struct LocalizableText: View {
    
    // Service locator
    @Injected private var repository: LocalizedStringProvider
    
    private let key: String
    @Binding var languageType: LanguageType
    
    init(key: String, languageType: Binding<LanguageType>) {
        self.key = key
        self._languageType = languageType
    }
    
    var body: some View {
        Text(repository.getString(key: key, lanCode: languageType.lanCode))
    }
}

