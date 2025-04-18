//
//  TabBarView.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

import SwiftUI

import AlertShooter

struct TabBarView: View {
    @StateObject private var viewModel: TabBarViewModel
    
    init(viewModel: TabBarViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.state.destinationPath) {
            tabBarContent()
                .navigationDestination(for: TabBarPageDestination.self) { desination in
                    viewModel.router?.view(desination)
                        .navigationBarBackButtonHidden()
                }
        }
        .onAppear { viewModel.action(.onAppear) }
        .alertShootable()
    }
    
    
    @ViewBuilder
    private func tabBarContent() -> some View {
        TabView {
            ForEach(viewModel.state.tabItemROs) { ro in
                Tab {
                    AnyView(viewModel.router?.tabBarPage(ro.page))
                } label: {
                    VStack {
                        Image(systemName: ro.displayIconName)
                        Text(ro.displayText)
                    }
                }
            }
        }
    }
}


