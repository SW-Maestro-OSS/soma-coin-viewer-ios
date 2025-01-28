//
//  SettingViewModel.swift
//  SettingModule
//
//  Created by 최재혁 on 12/23/24.
//

import SwiftUI
import Combine

import BaseFeature

import DomainInterface

import I18N
import CoreUtil

public protocol SettingViewModelListener: AnyObject {
    
    func mutation(gridType: GridType)
}

class SettingViewModel : UDFObservableObject, SettingViewModelable, SettingViewModelDelegate {
    
    // DI
    @Injected private var i18NManager: I18NManager
    @Injected private var userConfigurationRepository: UserConfigurationRepository
    @Injected private var repository: LanguageLocalizationRepository
    
    
    // Listener
    weak var listener: SettingViewModelListener?
    
    
    // State
    @Published var state : State = .init(
        currencyType: .dollar,
        languageType: .english,
        gridType: .list
    )
    
    
    var action : PassthroughSubject<Action, Never> = .init()
    var store : Set<AnyCancellable> = []
    
    init() {
        
        let initialCurrencyType = i18NManager.getCurrencyType()
        let initialLanType = i18NManager.getLanguageType()
        let initialGridType = userConfigurationRepository.getGridType()
        let initialState: State = .init(
            currencyType: initialCurrencyType,
            languageType: initialLanType,
            gridType: initialGridType
        )
        self._state = Published(initialValue: initialState)
        
        createStateStream()
    }
    
    private var isFirstAppear: Bool = true
    
    func mutate(_ action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .onAppear:
            
            if isFirstAppear {
                isFirstAppear = false
                let cellROs = createSettingCellROS()
                return Just(Action.cellViewModelsCreated(cellROs))
                    .eraseToAnyPublisher()
            }
            break
        default:
            break
        }
        return Just(action).eraseToAnyPublisher()
    }
    
    //Action 처리
    func reduce(_ action : Action, state : State) -> State {
        var newState = state
        switch action {
        case .tap(let type):
            switch type {
            case .currency:
                newState.currencyType = i18NManager.getCurrencyType()
            case .language:
                newState.languageType = i18NManager.getLanguageType()
            case .grid:
                newState.gridType = userConfigurationRepository.getGridType()
            }
        case .cellViewModelsCreated(let cellROS):
            newState.settingCellROs = cellROS
        default:
            return state
        }
        return newState
    }
    
    func action(_ action: Action) {
        self.action.send(action)
    }
}

extension SettingViewModel {
    struct State {
        //Store Property
        var currencyType: CurrencyType
        var languageType: LanguageType
        var gridType: GridType
        var settingCellROs : [SettingCellRO] = []
        //Operate Property
        
    }
    
    enum Action {
        case tap(ActionType)
        case onAppear
        case cellViewModelsCreated([SettingCellRO])
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
            userConfigurationRepository.setGrideType(type: gridType)
            listener?.mutation(gridType: gridType)
            action.send(.tap(.grid))
        }
    }
}

extension SettingViewModel {
    
    func createSettingCellROS() -> [SettingCellRO] {
        let currentState = state
        let lanCode = currentState.languageType.lanCode
        let settingCellROs = [
            SettingCellRO(
                cellType: "Setting_price",
                title: repository.getString(key: "Setting_price_title", lanCode: lanCode),
                option: repository.getString(key: "Setting_price_option", lanCode: lanCode),
                isSelected: currentState.currencyType == .won
            ),
            SettingCellRO(
                cellType: "Setting_language",
                title: repository.getString(key: "Setting_language_title", lanCode: lanCode),
                option: repository.getString(key: "Setting_language_option", lanCode: lanCode),
                isSelected: currentState.languageType == .korean
            ),
            SettingCellRO(
                cellType: "Setting_grid",
                title: repository.getString(key: "Setting_grid_title", lanCode: lanCode),
                option: repository.getString(key: "Setting_grid_option", lanCode: lanCode),
                isSelected: currentState.gridType == .list
            )
        ]
        
        return settingCellROs
    }
}
