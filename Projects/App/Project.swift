import ProjectDescription

let project = Project(
    name: "App",
    targets: [
        .target(
            name: "CoinViewer",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.CoinViewer",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "RootFeature", path: "../RootFeature")
            ]
        ),
        .target(
            name: "CoinViewerTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.CoinViewerTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "CoinViewer")]
        ),
    ]
)
