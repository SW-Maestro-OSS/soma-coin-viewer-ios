import ProjectDescription

let project = Project(
    name: "CoreUtil",
    targets: [
        .target(
            name: "CoreUtil",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.Utils.CoreUtil",
            sources: ["Sources/**"],
            dependencies: [
                
            ]
        ),
    ]
)


