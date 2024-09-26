import ProjectDescription

let project = Project(
    name: "PresentationUtil",
    targets: [
        .target(
            name: "PresentationUtil",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.Utils.PresentationUtil",
            sources: ["/**"],
            dependencies: [
                .project(target: "CoreUtil", path: "../CoreUtil")
            ]
        ),
    ]
)


