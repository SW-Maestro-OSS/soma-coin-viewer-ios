import ProjectDescription

let project = Project(
    name: "BaseFeature",
    targets: [
        .target(
            name: "BaseFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.BaseFeature",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Data", path: "../Data"),
                .project(target: "CommonUI", path: "../CommonUI"),
            ]
        )
    ]
)

