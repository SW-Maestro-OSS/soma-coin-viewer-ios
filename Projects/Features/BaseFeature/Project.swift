import ProjectDescription

let project = Project(
    name: "BaseFeature",
    targets: [
        .target(
            name: "BaseFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.Feature.BaseFeature",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Repository", path: "../../Data"),
                .project(target: "Domain", path: "../../Domain"),
                .project(target: "CommonUI", path: "../../DSKit")
            ]
        ),
        .target(
            name: "BaseFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.Feature.BaseFeatureTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "BaseFeature")]
        ),
    ]
)

