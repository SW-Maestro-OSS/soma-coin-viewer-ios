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
    @State var isSelected : Bool
    let settingCellRO : SettingCellRO
    let onToggle: (CellType) -> Void
    
    init(settingCellRO : SettingCellRO, onToggle : @escaping (CellType) -> Void) {
        self._isSelected = State(initialValue: settingCellRO.isSelected)
        self.settingCellRO = settingCellRO
        self.onToggle = onToggle
    }
    
    var body : some View {
        HStack {
            Spacer().frame(width : 16)
            
            VStack {
                Text(settingCellRO.title)
                    .font(.body)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            VStack (alignment : .trailing) {
                Text(settingCellRO.option)
                    .font(.body)
                    .foregroundColor(.gray)
                
                HStack {
                    Toggle("", isOn: $isSelected)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .gray))
                        .onChange(of: isSelected) { _ in
                            onToggle(settingCellRO.cellType) // 콜백 호출
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
