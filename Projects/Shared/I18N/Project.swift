//
//  Project.swift
//  Manifests
//
//  Created by 최재혁 on 12/13/24.
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "I18N",
    targets: [
        
        .target(
            name: "I18NTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.CoinViewer.I18N.tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "I18NTesting"),
            ]
        ),
        
        
        .target(
            name: "I18NTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.I18N.testing",
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "I18N"),
            ]
        ),
    
    
        .target(
            name: "I18N",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.I18N",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                
                D.Domain.interface,
                
                D.Util.CoreUtil,
            ]
        ),
    ]
)
