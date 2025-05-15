//
//  Environment.swift
//  Plugins
//
//  Created by choijunios on 4/22/25.
//

@preconcurrency import ProjectDescription

public extension Project {
    enum Environment {
        public static let deploymentTarget: DeploymentTargets = .iOS("18.0")
        public static let appVersion: String = "1.0.2"
        public static let bundleId: String = "com.soma.coinviewer"
    }
}
