//
//  SettingCellViewModel.swift
//  SettingModule
//
//  Created by 최재혁 on 1/7/25.
//

import SwiftUI
import Combine

import BaseFeature

import DomainInterface

import I18N
import CoreUtil

class SettingCellViewModel: UDFObservableObject, Identifiable {
    
    // Service locator
    @Injected private var i18NManager: I18NManager
    
    
    // Id
    let id: UUID = .init()
    
    
    // State
    @Published var state : State = .init(
        cellType: .currencyType(.dollar),
        titleKey: "",
        optionKey: "",
        isSelected: false,
        languageType: .english
    )
    
    
    // Delegage
    weak var delegate : SettingViewModelDelegate?
    
    
    var action : PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    init(cellValue : CellType, titleKey : String, optionKey : String, isSelected : Bool) {
        
        let initialLanType = i18NManager.getLanguageType()
        let initialState : State = .init(
            cellType: cellValue,
            titleKey: titleKey,
            optionKey: optionKey,
            isSelected: isSelected,
            languageType: initialLanType
        )
        self._state = .init(initialValue: initialState)

        createStateStream()
        
        i18NManager
            .getChangePublisher()
            .compactMap(\.languageType)
            .receive(on: RunLoop.main)
            .sink { [weak self] mutatedLanType in
                self?.action.send(.lanTypeUpdated(lanType: mutatedLanType))
            }
            .store(in: &store)
    }
    
    
    func reduce(_ action: Action, state: State) -> State {
        
        var newState = state
        switch action {
        case .lanTypeUpdated(let lanType):
            newState.languageType = lanType
        case .tap :
            newState.isSelected.toggle()
            switch newState.cellType {
            case .currencyType(let currencyType):
                let updatedCurrencyType: CurrencyType = (currencyType == .dollar) ? .won : .dollar
                newState.cellType = .currencyType(updatedCurrencyType)
                
            case .languageType(let languageType):
                let updatedCurrencyType: LanguageType = (languageType == .english) ? .korean : .english
                newState.cellType = .languageType(updatedCurrencyType)
                
            case .gridType(let gridType):
                let updatedGridType: GridType = (gridType == .list) ? .twoByTwo : .list
                newState.cellType = .gridType(updatedGridType)
            }
            
            delegate?.updateSetting(cellType: newState.cellType)
        }
        return newState
    }
}


// MARK: Action & State
extension SettingCellViewModel {
    
    enum Action {
        case tap
        case lanTypeUpdated(lanType: LanguageType)
    }
    
    struct State {
        var cellType: CellType
        var titleKey: String
        var optionKey: String
        var isSelected: Bool
        var languageType: LanguageType
    }
}
