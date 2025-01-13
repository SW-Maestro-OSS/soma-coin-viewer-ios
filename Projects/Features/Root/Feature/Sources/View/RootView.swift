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
        
        NavigationStack(path: viewModel.router?.getPath() ?? .constant(.init())) {
            
            SplashView()
                .navigationDestination(for: RootDestination.self) { destination in
                    
                    if let router = viewModel.router {
                        AnyView(router.destinationView(destination: destination))
                            .navigationBarBackButtonHidden()
                    } else {
                        
                        Text("Router not found")
                    }
                }
        }
        .onAppear {
            viewModel.action(.onAppear)
        }
    }
}
