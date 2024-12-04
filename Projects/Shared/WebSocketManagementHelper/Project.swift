//
//  Project.swift
//
//  Created by choijunios on 2024/11/15
//

import ProjectDescription
import ConfigurationPlugin
import DependencyPlugin

let project = Project(
    name: "WebSocketManagementHelper",
    targets: [

        // Implements
        .target(
            name: "WebSocketManagementHelper",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.choijunios.shared.WebSocketManagementHelper",
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "WebSocketManagementHelperInterface"),
            ]
        ),

        // Interface
        .target(
            name: "WebSocketManagementHelperInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.shared.WebSocketManagementHelper.interface",
            sources: ["Interface/**"],
            dependencies: [
                
                D.Data.dataSource,
                D.Util.CoreUtil,
            ]
        ),
    ]
)
