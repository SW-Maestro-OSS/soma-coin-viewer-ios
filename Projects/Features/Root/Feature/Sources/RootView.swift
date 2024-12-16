//
//  RootView.swift
//  RootModule
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI

import BaseFeatureInterface

public struct RootView: View {
    
    @StateObject private var viewModel: RootViewModel
    
    @ObservedObject private var router: Router
    
    @ViewBuilder private var destinationView: (RootDestination) -> any View
    
    init(viewModel: RootViewModel, router: Router, destinationView: @escaping (RootDestination) -> any View) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._router = ObservedObject(wrappedValue: router)
        self.destinationView = destinationView
    }
    
    public var body: some View {
        
        NavigationStack(path: $router.path) {
            
            VStack {
                
                Text("This is root view")
                
                if let socketState = viewModel.state.isWebSocketConnected {
                    Text("WebSocket is connected: \(socketState)")
                }
                
            }
                .navigationDestination(for: RootDestination.self) { destination in
                    
                    AnyView(destinationView(destination))
                        .navigationBarBackButtonHidden()
                }
        }
    }
}
