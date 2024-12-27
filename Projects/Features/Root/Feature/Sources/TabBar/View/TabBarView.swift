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
            
            ForEach(TabBarPage.orderedPages) { page in
                
                Tab {
                    
                    AnyView(destinationView(page))
                    
                } label: {
                    
                    TabBarItemView(tabItem: viewModel.state.tabItem[page]!)
                }
            }
        }
    }
}


