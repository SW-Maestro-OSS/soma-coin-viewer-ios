//
//  App.swift
//  RootModule
//
//  Created by choijunios on 11/15/24.
//

import SwiftUI

import RootFeature

@main
struct RootModuleApp: App {
    
    let rootCoordinator: RootCoordinator = .init()
    
    var body: some Scene {
        
        WindowGroup {
            rootCoordinator.start()
        }
    }
}
