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
            
            ForEach(TabBarPage.orderedPages) { page in
                
                Tab {
                    
                    if let router = viewModel.router {
                        AnyView(router.destinationView(page))
                    } else {
                        Text("Router not found")
                    }
                    
                } label: {
                    
                    TabBarItemView(tabItem: viewModel.state.tabItem[page]!)
                }
            }
        }
    }
}


