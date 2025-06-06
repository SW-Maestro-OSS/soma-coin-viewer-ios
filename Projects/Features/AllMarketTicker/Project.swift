//
//  Project.swift
//
//  Created by choijunios on 2024/11/01
//

import ProjectDescription
import ConfigurationPlugin
import DependencyPlugin

let project = Project(
    name: "AllMarketTickerModule",
    targets: [
        // Example
        .target(
            name: "AllMarketTickerFeatureExample",
            destinations: .iOS,
            product: .app,
            bundleId: "com.choijunios.feature.AllMarketTicker.example",
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .target(name: "AllMarketTickerFeature"),
                .target(name: "AllMarketTickerFeatureTesting"),
            ]
        ),


        // Tests
        .target(
            name: "AllMarketTickerFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.choijunios.feature.AllMarketTicker.tests",
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "AllMarketTickerFeature"),
                .target(name: "AllMarketTickerFeatureTesting"),
            ]
        ),

        
        // Testing
        .target(
            name: "AllMarketTickerFeatureTesting",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.choijunios.feature.AllMarketTicker.testing",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "AllMarketTickerFeature"),
            ]
        ),
        

        // Feature
        .target(
            name: "AllMarketTickerFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.choijunios.feature.AllMarketTicker",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                
                D.Feature.BaseFeature,
                D.Feature.CoinDetailFeature,
                
                D.Shared.I18N,
                D.Shared.AlertShooter,
                D.Shared.WebSocketManagementHelper,
                
                D.ThirdParty.SimpleImageProvider,
            ]
        ),
    ]
)
