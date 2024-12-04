//
//  RootView.swift
//  RootModule
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI

import BaseFeatureInterface

public struct RootView: View {
    
    @StateObject private var viewModel: RootViewModel = .init()
    
    @ObservedObject var router: Router
    @ViewBuilder var destinationView: (RootDestination) -> any View
    
    public var body: some View {
        
        NavigationStack(path: $router.path) {
            
            Text("This is root view\nWebSocket is connected: \(viewModel.state.isWebSocketConnected)")
                .navigationDestination(for: RootDestination.self) { destination in
                    
                    AnyView(destinationView(destination))
                }
        }
    }
}
