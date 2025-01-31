//
//  TabBarItemRO.swift
//  RootModule
//
//  Created by choijunios on 1/26/25.
//

struct TabBarItemRO: Identifiable {
    var id: TabBarPage { page }
    
    let page: TabBarPage
    var displayText: String
    var displayIconName: String
}
