//
//  Config.swift
//  CoinViewerManifests
//
//  Created by 최재혁 on 9/18/24.
//

import ProjectDescription

let config = Config(
    plugins: [
        .local(path: .relativeToRoot("Plugins/DependencyPlugin")),
    ]
)
