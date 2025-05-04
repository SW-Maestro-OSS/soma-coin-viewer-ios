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

public protocol SettingPageRouting: AnyObject { }

public protocol SettingPageListener: AnyObject { }

class SettingViewModel: UDFObservableObject, SettingViewModelable {
    // Dependency
    private let i18NManager: I18NManager
    private let useCase: SettingPageUseCase
    
    
    // Listener
    weak var listener: SettingPageListener?
    
    
    // Router
    weak var router: SettingPageRouting?
    
    
    // State
    @Published var state : State = .init(
        currencyType: .dollar,
        languageType: .english,
        gridType: .list
    )
    
    var action : PassthroughSubject<Action, Never> = .init()
    var store : Set<AnyCancellable> = []
    
    init(i18NManager: I18NManager, useCase: SettingPageUseCase) {
        self.i18NManager = i18NManager
        self.useCase = useCase
        
        let initialCurrencyType = i18NManager.getCurrencyType()
        let initialLanType = i18NManager.getLanguageType()
        let initialGridType = useCase.getGridType()
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
                let cellROs = createSettingCellROS(with : state)
                return Just(Action.cellROCreated(cellROs))
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
        case .update(let type):
            switch type {
            case .currencyType(let value):
                let updatedValue: CurrencyType = (value == .dollar) ? .won : .dollar
                i18NManager.setCurrencyType(type: updatedValue)
                newState.currencyType = updatedValue
            case .languageType(let value):
                let updatedValue: LanguageType = (value == .english) ? .korean : .english
                i18NManager.setLanguageType(type: updatedValue)
                newState.languageType = updatedValue
            case .gridType(let value):
                let updatedValue: GridType = (value == .list) ? .twoByTwo : .list
                useCase.setGridType(type: updatedValue)
                newState.gridType = updatedValue
            }
            newState.settingCellROs = createSettingCellROS(with: newState)
        case .cellROCreated(let cellROS):
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
        case update(CellType) //i18N update
        case onAppear
        case cellROCreated([SettingCellRO])
    }
    
    enum ActionType {
        case currency
        case language
        case grid
    }
}

extension SettingViewModel {
    
    func createSettingCellROS(with : State) -> [SettingCellRO] {
        let currentState = with
        let lanCode = currentState.languageType.lanCode
        let settingCellROs = [
            SettingCellRO(
                cellKey: "Setting_price",
                cellType: CellType.currencyType(currentState.currencyType),
                title: LocalizedStringProvider.instance().getString(key: "Setting_price_title", lanCode: lanCode),
                option: LocalizedStringProvider.instance().getString(key: "Setting_price_option", lanCode: lanCode),
                isSelected: currentState.currencyType == .won
            ),
            SettingCellRO(
                cellKey: "Setting_language",
                cellType: CellType.languageType(currentState.languageType),
                title: LocalizedStringProvider.instance().getString(key: "Setting_language_title", lanCode: lanCode),
                option: LocalizedStringProvider.instance().getString(key: "Setting_language_option", lanCode: lanCode),
                isSelected: currentState.languageType == .korean
            ),
            SettingCellRO(
                cellKey: "Setting_grid",
                cellType: CellType.gridType(currentState.gridType),
                title: LocalizedStringProvider.instance().getString(key: "Setting_grid_title", lanCode: lanCode),
                option: LocalizedStringProvider.instance().getString(key: "Setting_grid_option", lanCode: lanCode),
                isSelected: currentState.gridType == .list
            )
        ]
        
        return settingCellROs
    }
}
