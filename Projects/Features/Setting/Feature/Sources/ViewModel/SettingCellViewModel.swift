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

class SettingCellViewModel: UDFObservableObject {
    
    let type : String
    
    @Published var state : State
    
    weak var delegate : SettingViewModelDelegate?
    
    var action : PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    init(type : String, title : String, cellValue : CellType) {
        self.type = type
        //TODO: cellTyp을 어떤 식으로 초기화 할거임>> SettingViewModel에서 부터 어떻게 해야할지 다시 생각해봐야함. 이 부분 때문에 지금 진도 막힘
        let initialState : State = .init(
            cellType: cellValue,
            title: title
        )
        self._state = .init(initialValue: initialState)
    }
}

extension SettingCellViewModel {
    enum Action {
        //Event
        case tap
    }
    
    struct State {
        //저장 프로퍼티
        fileprivate var cellType : CellType
        public var title : String
        
        //연산 프로퍼티
        public var option : String {
            switch cellType {
            case .currencyType(let currencyType):
                "Dollar | Won"
            case .languageType(let languageType):
                "English | Korean"
            case .gridType(let gridType):
                "2x2 | List"
            }
        }
        
        public var isSelected : Bool {
            switch cellType {
            case .currencyType(let currencyType):
                currencyType == .won
            case .languageType(let languageType):
                languageType == .korean
            case .gridType(let gridType):
                gridType == .list
            }
        }
        
    }
}
