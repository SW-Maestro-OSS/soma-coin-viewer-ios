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
        
        
        // Testing
        .target(
            name: "BaseFeatureTesting",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.choijunios.feature.Base.testing",
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "BaseFeature"),
            ]
        ),


        // Feature
        .target(
            name: "BaseFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.feature.Base",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                D.Domain.interface,
                D.Shared.CommonUI,
                D.Util.CoreUtil,
            ]
        ),
    ]
)
