import ProjectDescription

let project = Project(
    name: "CommonUI",
    targets: [
        .target(
            name: "CommonUI",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.CoinViewer.CommonUI",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: []
        )
    ]
)

