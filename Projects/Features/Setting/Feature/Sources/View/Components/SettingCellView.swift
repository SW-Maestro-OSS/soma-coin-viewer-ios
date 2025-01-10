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

struct SettingCellViewTests : View {
    
    @ObservedObject private var viewModel : SettingCellViewModel
    
    init(viewModel : SettingCellViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body : some View {
        HStack(spacing : 0) {
            
        }
    }
}
