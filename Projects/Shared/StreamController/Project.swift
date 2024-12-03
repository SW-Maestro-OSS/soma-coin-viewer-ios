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
            name: "StreamControllerTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.choijunios.shared.StreamController.tests",
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "StreamController"),
                .target(name: "StreamControllerTesting"),
            ]
        ),


        // Implements
        .target(
            name: "StreamController",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.shared.StreamController",
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "StreamControllerInterface"),
            ]
        ),


        // Testing
        .target(
            name: "StreamControllerTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.shared.StreamController.testing",
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "StreamControllerInterface"),
            ]
        ),


        // Interface
        .target(
            name: "StreamControllerInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.shared.StreamController.interface",
            sources: ["Interface/**"],
            dependencies: [
                
            ]
        ),
    ]
)
