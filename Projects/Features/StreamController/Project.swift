//
//  Project.swift
//
//  Created by choijunios on 2024/11/15
//

import ProjectDescription
import ConfigurationPlugin
import DependencyPlugin

let project = Project(
    name: "StreamControllerModule",
    targets: [

        // Tests
        .target(
            name: "StreamControllerFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.choijunios.feature.StreamController.tests",
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "StreamControllerFeature"),
                .target(name: "StreamControllerFeatureTesting"),
            ]
        ),


        // Feature
        .target(
            name: "StreamControllerFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.feature.StreamController",
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                .target(name: "StreamControllerFeatureInterface"),
            ]
        ),


        // Testing
        .target(
            name: "StreamControllerFeatureTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.feature.StreamController.testing",
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "StreamControllerFeatureInterface"),
            ]
        ),


        // FeatureInterface
        .target(
            name: "StreamControllerFeatureInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.feature.StreamController.interface",
            sources: ["Interface/**"],
            dependencies: [
                
            ]
        ),
    ]
)
