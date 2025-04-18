//
//  RootView.swift
//  RootModule
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI

import BaseFeature

struct RootView: View {
    @StateObject private var viewModel: RootViewModel
    
    init(viewModel: RootViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if let splashRO = viewModel.state.splashRO {
                SplashView(renderObject: splashRO)
            } else { EmptyView() }
        }
        .fullScreenCover(item: $viewModel.state.rootDestination) { destination in
            viewModel.router.view(destination: destination)
        }
        .onAppear { viewModel.action(.onAppear) }
    }
}

struct RootBrachView: View {
    @Binding var destination: RootDestination
    var destinationView: (RootDestination) -> AnyView
    
    var body: some View {
        destinationView(destination)
    }
}
