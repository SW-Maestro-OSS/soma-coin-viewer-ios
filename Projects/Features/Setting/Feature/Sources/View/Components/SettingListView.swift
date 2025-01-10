//
//  SettingListView.swift
//  SettingModule
//
//  Created by 최재혁 on 1/10/25.
//

import SwiftUI

import CommonUI

struct SettingListView: View {
    
    @Binding private var listItems : [SettingCellViewModel]
    
    init(listItems: Binding<[SettingCellViewModel]>) {
        self._listItems = listItems
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(listItems, id: \.type) { viewModel in
                    SettingCellView(viewModel: viewModel)
                }
            }
        }
    }
}
