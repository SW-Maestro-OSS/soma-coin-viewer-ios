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
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                
                .target(name: "AllMarketTickerFeature"),
                .target(name: "AllMarketTickerFeatureTesting"),
                
                // Implements for demo app
                D.Shared.WebSocketManagementHelper,
                
                D.Data.dataSource,
                D.Data.repository,
                
                D.Domain.concrete,
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
            product: .framework,
            bundleId: "com.choijunios.feature.AllMarketTicker.testing",
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "AllMarketTickerFeature"),
            ]
        ),
        

        // Feature
        .target(
            name: "AllMarketTickerFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.feature.AllMarketTicker",
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                
                D.Feature.BaseFeature,
                
                D.Shared.CommonUI,
                D.Shared.WebSocketManagementHelper,
                D.Shared.I18N,
                
                D.ThirdParty.SimpleImageProvider,
            ]
        ),
    ]
)
