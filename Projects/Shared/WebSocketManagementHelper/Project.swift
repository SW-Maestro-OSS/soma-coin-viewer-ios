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
        
        .target(
            name: "WebSocketManagementHelperTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.CoinViewer.shared.WebSocketManagementHelper.tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "WebSocketManagementHelper"),
                .target(name: "WebSocketManagementHelperTesting"),
            ]
        ),
        
        .target(
            name: "WebSocketManagementHelperTesting",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.CoinViewer.shared.WebSocketManagementHelper.testing",
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "WebSocketManagementHelper"),
            ]
        ),
        
        .target(
            name: "WebSocketManagementHelper",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.shared.WebSocketManagementHelper",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Sources/**"],
            dependencies: [
                
                D.Data.dataSource,
                
                D.Shared.I18N,
                D.Shared.AlertShooter,
                
                D.Util.CoreUtil,
            ]
        ),
    ]
)
