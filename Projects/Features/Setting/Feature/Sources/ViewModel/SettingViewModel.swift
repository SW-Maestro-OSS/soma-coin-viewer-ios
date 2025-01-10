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
    
    //Sub ViewModel
    private var settingCellViewModel : [SettingCellViewModel] = []
    
    var action : PassthroughSubject<Action, Never> = .init()
    var store : Set<AnyCancellable> = []
    
    init() {
        var initialState : State = .init()
        self._state = Published(initialValue: initialState)
        self.state.currencyType = i18NManager.getCurrencyType()
        self.state.languageType = i18NManager.getLanguageType()
        self.state.gridType = i18NManager.getGridType()
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
    
    //Action에 따른 추가 action 처리
    func mutate(_ action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .tap(let type) :
            //I18N 모듈로 상태 전달 해야함. 근데 어떻게 하지..
            return Just(action).eraseToAnyPublisher()
        }
    }
    
}

extension SettingViewModel {
    struct State {
        //Store Property
        var currencyType : CurrencyType = CurrencyType.dollar
        var languageType : LanguageType = LanguageType.english
        var gridType : GridType = GridType.list
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
    func updateSetting(settingType : String, settingValue : String) {
        // 선택된 기준을 I18NManager 통해 전달
        //action으로 전달하고 이를 state에 저장 -> state를 string이나 다른 값으로 변경 필요
        //TODO: 처음 정렬 기준을 하위 viewModel에 전달할 필요 있음
        if settingType == "currencyType" {
            let currencyType = CurrencyType(rawValue: settingValue)!
            i18NManager.setCurrencyType(type: currencyType)
            action.send(.tap(.currency))
        } else if settingType == "languageType" {
            let languageType = LanguageType(rawValue: settingValue)!
            i18NManager.setLanguageType(type: languageType)
            action.send(.tap(.language))
        } else if settingType == "gridType" {
            let gridType = GridType(rawValue: settingValue)!
            i18NManager.setGridType(type: gridType)
            action.send(.tap(.grid))
        }
    }
}

extension SettingViewModel {
    func createSettingCellViewModels() -> [SettingCellViewModel] {
        let viewModels = [
            SettingCellViewModel(type: "currencyType", title: "Price Currency Unit", cellValue: CellType.currencyType(state.currencyType)),
            SettingCellViewModel(type: "languageType", title: "Language", cellValue: CellType.languageType(state.languageType)),
            SettingCellViewModel(type: "gridType", title: "Show symbols with 2x2 grid", cellValue: CellType.gridType(state.gridType))
        ]
        
        return viewModels
    }
}

enum CellType {
    case currencyType(CurrencyType)
    case languageType(LanguageType)
    case gridType(GridType)
}
