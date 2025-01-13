//
//  Project.swift
//
//  Created by choijunios on 2024/11/01
//

import ProjectDescription
import ConfigurationPlugin
import DependencyPlugin

let project = Project(
    name: "SettingModule",
    targets: [
        

        // Example
        .target(
            name: "SettingFeatureExample",
            destinations: .iOS,
            product: .app,
            bundleId: "com.choijunios.feature.Setting.example",
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .target(name: "SettingFeature"),
                .target(name: "SettingFeatureTesting"),
                
                D.Data.dataSource,
                D.Data.repository,
                
                D.Domain.concrete,
            ]
        ),


        // Tests
        .target(
            name: "SettingFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.choijunios.feature.Setting.tests",
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "SettingFeature"),
                .target(name: "SettingFeatureTesting"),
            ]
        ),
        
      
        // Testing
        .target(
            name: "SettingFeatureTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.feature.Setting.testing",
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "SettingFeature"),
            ]
        ),


        // Feature
        .target(
            name: "SettingFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.choijunios.feature.Setting",
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                D.Feature.BaseFeature,
                
                D.Shared.CommonUI,
                D.Shared.I18N,
            ]
        ),
    ]
)
