import ProjectDescription

let project = Project(
    name: "RootFeature",
    targets: [
        .target(
            name: "RootFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.RootFeature",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "BaseFeature", path: "../BaseFeature")
            ]
        )
    ]
)

