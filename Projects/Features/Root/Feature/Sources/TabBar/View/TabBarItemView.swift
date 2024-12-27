//
//  TabBarItemView.swift
//  RootModule
//
//  Created by choijunios on 12/16/24.
//

import SwiftUI

struct TabBarItemView: View {
    
    let tabItem: TabItem
    
    var body: some View {
        
        VStack {
            Image(systemName: tabItem.systemIconName)
            Text(tabItem.titleText)
        }
    }
}
