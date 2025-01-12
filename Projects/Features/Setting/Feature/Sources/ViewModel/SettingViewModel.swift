//
//  SettingViewModel.swift
//  SettingModule
//
//  Created by 최재혁 on 12/23/24.
//

import SwiftUI
import Combine

import BaseFeatureInterface
import DomainInterface
import I18NInterface
import CoreUtil

class SettingViewModel : UDFObservableObject, SettingViewModelDelegate {
    //Service Locator
    @Injected var i18NManager :I18NManager
    
    //Publishing State
    @Published var state : State
    
    var action : PassthroughSubject<Action, Never> = .init()
    var store : Set<AnyCancellable> = []
    
    init() {
        let initialState : State = .init()
        self._state = Published(initialValue: initialState)
        self.state.currencyType = i18NManager.getCurrencyType()
        self.state.languageType = i18NManager.getLanguageType()
        self.state.gridType = i18NManager.getGridType()
        self.state.settingCellViewModel = createSettingCellViewModels()
        
        i18NManager.setExchangeRate()
        createStateStream()
        
        print(state)
    }
    
    //Action 처리
    func reduce(_ action : Action, state : State) -> State {
        switch action {
        case .tap(let type) :
            var newState = state
            
            switch type {
            case .currency :
                newState.currencyType = i18NManager.getCurrencyType()
            case .language :
                newState.languageType = i18NManager.getLanguageType()
            case .grid :
                newState.gridType = i18NManager.getGridType()
            }
            return newState
        }
    }
}

extension SettingViewModel {
    struct State {
        //Store Property
        var currencyType : CurrencyType = CurrencyType.dollar
        var languageType : LanguageType = LanguageType.english
        var gridType : GridType = GridType.list
        var settingCellViewModel : [SettingCellViewModel] = []
        //Operate Property
        
    }
    
    enum Action {
        case tap(ActionType)
    }
    
    enum ActionType {
        case currency
        case language
        case grid
    }
}

//MARK: SettingDelegate
extension SettingViewModel {
    func updateSetting(cellType : CellType) {
        switch cellType {
        case .currencyType(let currencyType):
            i18NManager.setCurrencyType(type: currencyType)
            action.send(.tap(.currency))
        case .languageType(let languageType):
            i18NManager.setLanguageType(type: languageType)
            action.send(.tap(.language))
        case .gridType(let gridType):
            i18NManager.setGridType(type: gridType)
            action.send(.tap(.grid))
        }
    }
}

extension SettingViewModel {
    func createSettingCellViewModels() -> [SettingCellViewModel] {
        let viewModels = [
            SettingCellViewModel(title: "Price Currency Unit", cellValue: CellType.currencyType(state.currencyType), option: "Dollar | Won", isSelected: state.currencyType == .won),
            SettingCellViewModel(title: "Language", cellValue: CellType.languageType(state.languageType), option: "English | Korean", isSelected: state.languageType == .korean),
            SettingCellViewModel(title: "Show symbols with 2x2 grid", cellValue: CellType.gridType(state.gridType), option: "2x2 | List", isSelected: state.gridType == .list)
        ]
        
        viewModels.forEach{ viewModel in
            viewModel.delegate = self
        }
        
        return viewModels
    }
}

enum CellType {
    case currencyType(CurrencyType)
    case languageType(LanguageType)
    case gridType(GridType)
}
