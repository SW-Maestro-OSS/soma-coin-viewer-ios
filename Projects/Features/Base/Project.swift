//
//  Project.swift
//
//  Created by choijunios on 2024/11/01
//

import ProjectDescription
import ConfigurationPlugin
import DependencyPlugin

let project = Project(
    name: "BaseModule",
    targets: [
        

        // Example
        .target(
            name: "BaseFeatureExample",
            destinations: .iOS,
            product: .app,
            bundleId: "com.choijunios.feature.Base.example",
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .target(name: "BaseFeature"),
                .target(name: "BaseFeatureTesting"),
            ]
        ),


        // Tests
        .target(
            name: "BaseFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.choijunios.feature.Base.tests",
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "BaseFeature"),
                .target(name: "BaseFeatureTesting"),
            ]
        ),


        // Feature
        .target(
            name: "BaseFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.feature.Base",
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                .target(name: "BaseFeatureInterface"),
                
                D.Util.PresentationUtil,
            ]
        ),


        // Testing
        .target(
            name: "BaseFeatureTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.feature.Base.testing",
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "BaseFeatureInterface"),
            ]
        ),


        // FeatureInterface
        .target(
            name: "BaseFeatureInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.feature.Base.interface",
            sources: ["Interface/**"],
            dependencies: [
                
                D.Shared.CommonUI,
                D.Shared.WebSocketManagementHelperInterface,
                D.Domain.interface,
            ]
        ),
    ]
)
