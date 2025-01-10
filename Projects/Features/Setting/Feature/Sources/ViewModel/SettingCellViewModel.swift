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
import CoreUtil

class SettingCellViewModel: UDFObservableObject, Identifiable {
    let id : String
    
    @Published var state : State
    
    weak var delegate : SettingViewModelDelegate?
    
    var action : PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    init(title : String, cellValue : CellType, option : String, isSelected : Bool) {
        let initialState : State = .init(
            cellType: cellValue,
            title: title,
            option: option,
            isSelected: isSelected
        )
        self._state = .init(initialValue: initialState)
        self.id = title
    }
    
    //Action처리
    func reduce(_ action: Action, state: State) -> State {
        switch action {
        case .tap :
            var newState = state
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
            print(newState)
            return newState
        }
    }
    
    //Action에 따른 추가 action처리
    func mutate(_ action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .tap :
            delegate?.updateSetting(cellType: state.cellType)
            return Just(action).eraseToAnyPublisher()
        }
    }
}

extension SettingCellViewModel {
    enum Action {
        //Event
        case tap
    }
    
    struct State {
        //저장 프로퍼티
        public var cellType : CellType
        public var title : String
        public var option : String
        public var isSelected : Bool
        
        //연산 프로퍼티
        
    }
}
