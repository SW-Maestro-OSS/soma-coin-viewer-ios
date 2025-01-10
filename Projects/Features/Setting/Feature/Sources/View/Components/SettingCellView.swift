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

struct SettingCellView : View {
    
    @ObservedObject private var viewModel : SettingCellViewModel
    
    init(viewModel : SettingCellViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body : some View {
        HStack {
            Spacer().frame(width : 16)
            
            VStack {
                CVText(text : $viewModel.state.title)
                    .font(.body)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            VStack (alignment : .trailing) {
                CVText(text: $viewModel.state.option)
                    .font(.body)
                    .foregroundColor(.gray)
                
                HStack {
                    Toggle("",isOn : $viewModel.state.isSelected)
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

//#Preview {
//    SettingCellViewTests(viewModel: SettingCellViewModel(type: "preview", title: "PreviewTitle", cellValue: CellType.currencyType(CurrencyType.dollar), option: "Dollar | Won", isSelected: false))
//}
