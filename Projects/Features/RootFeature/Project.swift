import ProjectDescription

let project = Project(
    name: "RootFeature",
    targets: [
        .target(
            name: "RootFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.Feature.RootFeature",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "BaseFeature", path: "../BaseFeature")
            ]
        ),
        .target(
            name: "RootFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.Feature.RootFeatureTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "RootFeature")]
        ),
    ]
)

