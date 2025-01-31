//
//  StubLanguageLocalizationRepository.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/23/25.
//

import I18N

class StubLanguageLocalizationRepository: LanguageLocalizationRepository {
    
    func getString(key: String, lanCode: String) -> String { "Test" }
}
