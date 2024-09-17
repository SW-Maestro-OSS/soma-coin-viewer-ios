import ProjectDescription

let project = Project(
    name: "Data",
    targets: [
        .target(
            name: "Data",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.CoinViewer.Data",
            sources: ["DataSource/**", "DTO/**", "Repository/**"],
            dependencies: [
                .project(target: "Domain", path: "../Domain")
            ]
        )
    ]
)
