//
//  Project.swift
//
//  Created by choijunios on 2024/11/01
//

import ProjectDescription
import ConfigurationPlugin
import DependencyPlugin

let project = Project(
    name: "RootModule",
    targets: [
        // Example
        .target(
            name: "RootFeatureExample",
            destinations: .iOS,
            product: .app,
            bundleId: "com.choijunios.feature.Root.example",
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .target(name: "RootFeature"),
                .target(name: "RootFeatureTesting"),
            ]
        ),


        // Tests
        .target(
            name: "RootFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.choijunios.feature.Root.tests",
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "RootFeature"),
                .target(name: "RootFeatureTesting"),
            ]
        ),
        
        
        // Testing
        .target(
            name: "RootFeatureTesting",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.choijunios.feature.Root.testing",
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "RootFeature"),
            ]
        ),


        // Feature
        .target(
            name: "RootFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.choijunios.feature.Root",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                
                D.Feature.AllMarketTickerFeature,
                D.Feature.SettingFeature,
                
                D.Shared.AlertShooter,
            ]
        ),
    ]
)
