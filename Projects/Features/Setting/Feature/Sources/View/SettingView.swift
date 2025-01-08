//
//  SettingView.swift
//  SettingModule
//
//  Created by 최재혁 on 12/23/24.
//

import SwiftUI

import CommonUI
import CoreUtil

struct SettingView : View {
        
    @StateObject private var viewModel: SettingViewModel
    
    init(viewModel: SettingViewModel) {
        
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer().frame(width : 16)
                
                VStack {
                    Text("Price Currency Unit")
                        .font(.title)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                VStack {
                    Text("Dollar | Won")
                        .font(.title)
                        .foregroundColor(.gray)
                    
                    Toggle("",isOn : Binding(
                        get: {viewModel.state.priceUnit},
                        set: { _ in viewModel.action.send(.tap(.priceUnit))}
                    ))
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .gray))
                }
                
                Spacer().frame(width : 16)
            }
            
            HStack {
                Spacer().frame(width : 16)
                
                VStack {
                    Text("Language")
                        .font(.title)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                VStack {
                    Text("English | Korean")
                        .font(.title)
                        .foregroundColor(.gray)
                    
                    Toggle("",isOn : Binding(
                        get: {viewModel.state.language},
                        set: { _ in viewModel.action.send(.tap(.language))}
                    ))
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .gray))
                }
                
                Spacer().frame(width : 16)
            }
            
            HStack {
                Spacer().frame(width : 16)
                
                VStack {
                    Text("Show symbol with \n2x2 grid")
                        .font(.title)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                VStack {
                    //TODO: toggle Bind를 어떤 식으로 변경 할 것인지 관리할 필요가 있음
                    Toggle("",isOn : Binding(
                        get: {viewModel.state.gride},
                        set: { _ in viewModel.action.send(.tap(.gride))}
                    ))
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .gray))
                }
                
                Spacer().frame(width : 16)
            }
        }
    }
}
//
//struct SettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingView(viewModel: SettingViewModel())
//    }
//}
