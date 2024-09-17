import ProjectDescription

let project = Project(
    name: "CoinViewer",
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
            sources: ["CoinViewer/Sources/**"],
            resources: ["CoinViewer/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "CoinViewerTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.CoinViewerTests",
            infoPlist: .default,
            sources: ["CoinViewer/Tests/**"],
            resources: [],
            dependencies: [.target(name: "CoinViewer")]
        ),
    ]
)
