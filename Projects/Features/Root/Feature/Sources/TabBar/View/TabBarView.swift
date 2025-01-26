//
//  TabBarView.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

import SwiftUI

struct TabBarView: View {
    
    @StateObject private var viewModel: TabBarViewModel
    
    init(viewModel: TabBarViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        TabView {
            ForEach(viewModel.state.tabItemROs) { ro in
                Tab {
                    AnyView(viewModel.router!.destinationView(ro.page))
                } label: {
                    VStack {
                        Image(systemName: ro.displayIconName)
                        Text(ro.displayText)
                    }
                }
            }
        }
        .onAppear { viewModel.action(.onAppear) }
    }
}


