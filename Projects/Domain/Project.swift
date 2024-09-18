import ProjectDescription

let project = Project(
    name: "Domain",
    targets: [
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.Domain",
            sources: ["RepositoryInterface/**", "VO/**"],
            dependencies: []
        )
    ]
)

