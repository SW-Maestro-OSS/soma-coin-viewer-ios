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
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .target(name: "CoinDetailFeature"),
                .target(name: "CoinDetailFeatureTesting"),
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
            product: .framework,
            bundleId: "com.choijunios.feature.CoinDetail.testing",
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "CoinDetailFeature"),
            ]
        ),


        // Feature
        .target(
            name: "CoinDetailFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.feature.CoinDetail",
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                D.Feature.BaseFeature,
            ]
        ),
    ]
)
