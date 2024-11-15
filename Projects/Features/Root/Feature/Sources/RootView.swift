//
//  RootView.swift
//  RootModule
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI

import BaseFeatureInterface

public struct RootView: View {
    
    @ObservedObject var nPathController: NPathController<RootDestination>
    @ViewBuilder var destinationView: (RootDestination) -> any View
    
    public var body: some View {
        
        NavigationStack(path: $nPathController.path) {
            
            Text("This is root view")
                .navigationDestination(for: RootDestination.self) { destination in
                    
                    AnyView(destinationView(destination))
                }
        }
    }
}
