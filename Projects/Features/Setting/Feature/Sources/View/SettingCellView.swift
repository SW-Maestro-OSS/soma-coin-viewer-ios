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
    @Binding var isSelected : Bool
    let onToggle: (String type) -> Void
    
    init(isSelected : Binding<Bool>) {
        self._isSelected = isSelected
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
                    Toggle("", isOn: $isSelected)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .gray))
                        .onChange(of: isSelected) { _ in
                            onToggle() // 콜백 호출
                        }
                    
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
