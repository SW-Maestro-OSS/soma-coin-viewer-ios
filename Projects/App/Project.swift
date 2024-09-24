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
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ]
                            ]
                        ]
                    ]
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "RootFeature", path: "../Feature/RootFeature")
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
