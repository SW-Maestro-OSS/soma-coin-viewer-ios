//
//  TabBarView.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

import SwiftUI

struct TabBarView: View {
    
    @StateObject private var viewModel: TabBarViewModel
    @ViewBuilder private var destinationView: (TabBarPage) -> any View
    
    init(viewModel: TabBarViewModel, destinationView: @escaping (TabBarPage) -> any View) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.destinationView = destinationView
    }
    
    var body: some View {
        
        TabView {
            
            ForEach($viewModel.state.presentingPages) { page in
                
                Tab {
                    
                    AnyView(destinationView(page.wrappedValue))
                    
                } label: {
                    
                    TabBarItemView(tabItem: viewModel.binding(page: page.wrappedValue))
                }
                
            }
        }
    }
}


