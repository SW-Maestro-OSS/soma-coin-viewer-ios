//
//  DefaultLocalizedStringDataSourceTests.swift
//  I18N
//
//  Created by choijunios on 5/14/25.
//

import Testing

@testable import I18N
import DomainInterface
import I18NTesting

struct DefaultLocalizedStringDataSourceTests {
    @Test("Alert에 필요한 스트링 확인", arguments: [
        LanguageType.korean,
        LanguageType.english
    ])
    func checkAlertStrings(languageType: LanguageType) {
        // Given
        let dataSource = DefaultLocalizedStringDataSource()
        
        
        // When
        let keys = [
            AlertContents.Title.allCases.map {
                LocalizedStrKey.alertKey(contents: .title($0))
            },
            AlertContents.Message.allCases.map {
                LocalizedStrKey.alertKey(contents: .message($0))
            },
            AlertContents.ActionTitle.allCases.map {
                LocalizedStrKey.alertKey(contents: .actionTitle($0))
            },
        ].flatMap({ $0 })
        
        let strings = keys.compactMap({
            dataSource.getString(
                key: $0.key,
                lanCode: languageType.lanCode)
        })
        
        
        // Then
        #expect(strings.count == keys.count)
    }
}
