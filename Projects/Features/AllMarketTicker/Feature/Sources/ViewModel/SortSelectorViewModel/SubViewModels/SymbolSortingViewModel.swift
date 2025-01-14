//
//  SymbolSortingViewModel.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/14/25.
//

import DomainInterface

import I18N
import CoreUtil

final class SymbolSortingViewModel: TickerSortSelectorViewModel {
    
    @Injected private var languageLocalizationRepository: LanguageLocalizationRepository
    @Injected private var i18NManager: I18NManager
    
    init() {
        super.init(config: .init(
            intialTitleText: "",
            ascending: TickerSymbolAscendingComparator(),
            descending: TickerSymbolDescendingComparator())
        )
        
        let languageType = i18NManager.getLanguageType()
        updateText(languageType: languageType)
    }
    
    func updateText(languageType: LanguageType) {
        let key = "AllMarketTickerPage_comparator_symbol"
        let localizedString = languageLocalizationRepository.getString(
            key: key,
            lanCode: languageType.lanCode
        )
        action.send(.changeTitleText(localizedString))
    }
}
