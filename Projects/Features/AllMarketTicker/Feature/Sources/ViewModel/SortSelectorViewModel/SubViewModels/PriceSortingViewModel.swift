//
//  PriceSortingViewModel.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/14/25.
//

import Foundation

import DomainInterface

import I18N

import CoreUtil

final class PriceSortingViewModel: TickerSortSelectorViewModel {
    
    @Injected private var languageLocalizationRepository: LanguageLocalizationRepository
    @Injected private var i18NManager: I18NManager
    
    
    // State
    private var currentLanType: LanguageType = .english
    private var currentCurrencyType: CurrencyType = .dollar
    
    init() {
        
        super.init(config: .init(
            intialTitleText: "",
            ascending: TickerPriceAscendingComparator(),
            descending: TickerPriceDescendingComparator())
        )
        
        let languageType = i18NManager.getLanguageType()
        let currencyType = i18NManager.getCurrencyType()
        self.currentLanType = languageType
        self.currentCurrencyType = currencyType
        updateTitle(languageType: languageType, currencyType: currencyType)
        
        i18NManager
            .getChangePublisher()
            .receive(on: RunLoop.main)
            .sink { [weak self] mutation in
                guard let self else { return }
                updateTitle(
                    languageType: mutation.languageType,
                    currencyType: mutation.currencyType
                )
            }
            .store(in: &store)
    }
    
    private func updateTitle(languageType: LanguageType?, currencyType: CurrencyType?) {
        
        let key = "AllMarketTickerPage_comparator_price"
        
        let lanType = languageType ?? currentLanType
        let curType = currencyType ?? currentCurrencyType
        
        var localizedString = languageLocalizationRepository.getString(
            key: key,
            lanCode: lanType.lanCode
        )
        localizedString = "\(localizedString)(\(curType.symbol))"
        action.send(.changeTitleText(localizedString))
        self.currentLanType = lanType
        self.currentCurrencyType = curType
    }
}
