//
//  ChangeIn24hViewModel.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/14/25.
//

import Foundation

import DomainInterface

import I18N
import CoreUtil

final class ChangeIn24hViewModel: TickerSortSelectorViewModel {
    
    @Injected private var languageLocalizationRepository: LanguageLocalizationRepository
    @Injected private var i18NManager: I18NManager
    
    init() {
        super.init(config: .init(
            intialTitleText: "",
            ascending: Ticker24hChangeAscendingComparator(),
            descending: Ticker24hChangeDescendingComparator())
        )
        
        let languageType = i18NManager.getLanguageType()
        updateText(languageType: languageType)
        
        i18NManager
            .getChangePublisher()
            .compactMap({ $0.languageType })
            .receive(on: RunLoop.main)
            .sink { [weak self] mutatedLanType in
                guard let self else { return }
                updateText(languageType: mutatedLanType)
            }
            .store(in: &store)
    }
    
    func updateText(languageType: LanguageType) {
        let key = "AllMarketTickerPage_comparator_24hchange"
        let localizedString = languageLocalizationRepository.getString(
            key: key,
            lanCode: languageType.lanCode
        )
        action.send(.changeTitleText(localizedString))
    }
}
