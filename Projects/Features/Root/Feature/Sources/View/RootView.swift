//
//  RootView.swift
//  RootModule
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI

import BaseFeature

struct RootView: View {
    
    // View model
    @StateObject private var viewModel: RootViewModel
    
    init(viewModel: RootViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.state.isLoading {
                SplashView(renderObject: viewModel.state.splashRO)
            } else {
                NavigationStack(path: viewModel.router?.getPath() ?? .constant(.init())) {
                    EmptyView()
                        .navigationDestination(for: RootDestination.self) { destination in
                            AnyView(viewModel.router!.destinationView(destination: destination))
                                .navigationBarBackButtonHidden()
                        }
                }
            }
        }
        .animation(.easeIn(duration: 0.2), value: viewModel.state.isLoading)
        .onAppear { viewModel.action(.onAppear) }
        .alertable(
            presented: $viewModel.state.presentAlert,
            renderObject: viewModel.state.alertRO
        )
    }
}
