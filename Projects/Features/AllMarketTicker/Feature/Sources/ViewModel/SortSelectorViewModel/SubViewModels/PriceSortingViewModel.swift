//
//  PriceSortingViewModel.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/14/25.
//

import DomainInterface

import I18N

import CoreUtil

final class PriceSortingViewModel: TickerSortSelectorViewModel {
    
    @Injected private var languageLocalizationRepository: LanguageLocalizationRepository
    @Injected private var i18NManager: I18NManager
    
    init() {
        super.init(config: .init(
            intialTitleText: "",
            ascending: TickerPriceAscendingComparator(),
            descending: TickerPriceDescendingComparator())
        )
        
        let languageType = i18NManager.getLanguageType()
        let currencyType = i18NManager.getCurrencyType()
        updateTitle(languageType: languageType, currencyType: currencyType)
    }
    
    private func updateTitle(languageType: LanguageType, currencyType: CurrencyType) {
        let key = "AllMarketTickerPage_comparator_price"
        var localizedString = languageLocalizationRepository.getString(
            key: key,
            lanCode: languageType.lanCode
        )
        localizedString = "\(localizedString)(\(currencyType.symbol))"
        action.send(.changeTitleText(localizedString))
    }
}
