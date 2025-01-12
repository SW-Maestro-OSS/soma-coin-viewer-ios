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
            SettingListView(listItems: $viewModel.state.settingCellViewModel)
        }
    }
}
