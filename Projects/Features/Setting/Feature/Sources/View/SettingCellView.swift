//
//  SettingCellView.swift
//  SettingModule
//
//  Created by 최재혁 on 12/23/24.
//

import SwiftUI
import Combine

import CommonUI
import DomainInterface
import CoreUtil

import I18N

struct SettingCellView : View {
    
    @ObservedObject private var viewModel: SettingCellViewModel
    
    init(viewModel: SettingCellViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body : some View {
        HStack {
            Spacer().frame(width : 16)
            
            VStack {
                
                LocalizableText(
                    key: viewModel.state.titleKey,
                    languageType: $viewModel.state.languageType
                )
                .font(.body)
                .foregroundColor(.black)
            }
            
            Spacer()
            
            VStack (alignment : .trailing) {
                
                LocalizableText(
                    key: viewModel.state.optionKey,
                    languageType: $viewModel.state.languageType
                )
                .font(.body)
                .foregroundColor(.gray)
                
                HStack {
                    Toggle("",isOn : Binding(
                        get : { viewModel.state.isSelected },
                        set : { _ in viewModel.action.send(.tap) }
                    ))
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .gray))
                    
                    Spacer()
                        .frame(width : 16)
                }
            }
            
            Spacer().frame(width : 16)
        }
        .frame(height: 80)
        .background(
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black)
            }
        )
    }
}
