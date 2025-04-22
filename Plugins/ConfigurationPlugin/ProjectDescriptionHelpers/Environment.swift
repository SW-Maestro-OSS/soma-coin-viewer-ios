//
//  Environment.swift
//  Plugins
//
//  Created by choijunios on 4/22/25.
//

@preconcurrency import ProjectDescription

public extension Project {
    enum Environment {
        public static let deploymentTarget: DeploymentTargets = .iOS("17.0")
    }
}
