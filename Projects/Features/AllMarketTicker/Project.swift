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


        // Feature
        .target(
            name: "AllMarketTickerFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.feature.AllMarketTicker",
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                .target(name: "AllMarketTickerFeatureInterface"),
                
                D.Util.PresentationUtil,
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
                .target(name: "AllMarketTickerFeatureInterface"),
            ]
        ),


        // FeatureInterface
        .target(
            name: "AllMarketTickerFeatureInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.feature.AllMarketTicker.interface",
            sources: ["Interface/**"],
            dependencies: [
                D.Feature.BaseFeatureInterface,
            ]
        ),
    ]
)
