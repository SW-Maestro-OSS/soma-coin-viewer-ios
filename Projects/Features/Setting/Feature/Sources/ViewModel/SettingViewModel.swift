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


class SettingViewModel : UDFObservableObject, SettingViewModelDelegate {
    //Service Locator
    private var i18NManager :I18NManager
    
    //Publishing State
    @Published var state : State
    
    var action : PassthroughSubject<Action, Never> = .init()
    var store : Set<AnyCancellable> = []
    
    init() {
        let initialState : State = .init()
        self._state = Published(initialValue: initialState)
    }
    
    //Action 처리
    func reduce(_ action : Action, state : State) -> State {
        switch action {
        case .tap(let type) :
            var newState = state
            
            switch type {
            case .priceUnit :
                newState.priceUnit.toggle()
            case .language :
                newState.language.toggle()
            case .gride :
                newState.gride.toggle()
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
        var priceUnit : Bool = false
        var language : Bool = false
        var gride : Bool = false
        //Operate Property
        
    }
    
    enum Action {
        case tap(ActionType)
    }
    
    enum ActionType {
        case priceUnit
        case language
        case gride
    }
}

//MARK: SettingDelegate
extension SettingViewModel {
    func updateSetting() {
        // 선택된 기준을 I18NManager 통해 전달
    }
}
