//
//  Project.swift
//
//  Created by choijunios on 2025/01/30
//

import ProjectDescription

import ConfigurationPlugin
import DependencyPlugin

let project = Project(
    name: "AlertShooter",
    targets: [
        
        .target(
            name: "AlertShooterTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.CoinViewer.shared.AlertShooter.tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "AlertShooter"),
                .target(name: "AlertShooterTesting"),
            ]
        ),
        
        .target(
            name: "AlertShooterTesting",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.CoinViewer.shared.AlertShooter.testing",
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "AlertShooter"),
            ]
        ),
        
        .target(
            name: "AlertShooter",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.shared.AlertShooter",
            sources: ["Sources/**"],
            dependencies: [
                D.Shared.I18N,
                D.Util.CoreUtil,
            ]
        ),
    ]
)
