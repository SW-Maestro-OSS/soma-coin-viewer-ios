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


        // Feature
        .target(
            name: "RootFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.feature.Root",
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                .target(name: "RootFeatureInterface"),
                
                D.Util.PresentationUtil,
            ]
        ),


        // Testing
        .target(
            name: "RootFeatureTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.feature.Root.testing",
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "RootFeatureInterface"),
            ]
        ),


        // FeatureInterface
        .target(
            name: "RootFeatureInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.feature.Root.interface",
            sources: ["Interface/**"],
            dependencies: [
                D.Feature.AllMarketTickerFeatureInterface,
                D.Feature.SettingFeatureInterface,
            ]
        ),
    ]
)
