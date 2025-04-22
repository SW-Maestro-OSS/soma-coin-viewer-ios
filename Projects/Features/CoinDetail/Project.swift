//
//  Project.swift
//
//  Created by choijunios on 2025/04/12
//

import ProjectDescription
import ConfigurationPlugin
import DependencyPlugin

let project = Project(
    name: "CoinDetailModule",
    targets: [
        // Example
        .target(
            name: "CoinDetailFeatureExample",
            destinations: .iOS,
            product: .app,
            bundleId: "com.choijunios.feature.CoinDetail.example",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .target(name: "CoinDetailFeature"),
                .target(name: "CoinDetailFeatureTesting"),
                
                D.Data.repository,
                D.Domain.concrete,
                D.Shared.WebSocketManagementHelper,
                D.Shared.AlertShooter,
                D.Data.dataSource,
            ]
        ),


        // Tests
        .target(
            name: "CoinDetailFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.choijunios.feature.CoinDetail.tests",
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "CoinDetailFeature"),
                .target(name: "CoinDetailFeatureTesting"),
            ]
        ),


        // Testing
        .target(
            name: "CoinDetailFeatureTesting",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.choijunios.feature.CoinDetail.testing",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "CoinDetailFeature"),
            ]
        ),


        // Feature
        .target(
            name: "CoinDetailFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.choijunios.feature.CoinDetail",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                D.Feature.BaseFeature,
                D.Shared.AlertShooter,
                D.Shared.WebSocketManagementHelper,
            ]
        ),
    ]
)
