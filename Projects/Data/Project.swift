import ProjectDescription

let project = Project(
    name: "Data",
    targets: [
        .target(
            name: "DataSource",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.Data.DataSource",
            sources: ["DataSource/Sources/**"],
            resources: ["DataSource/Resources/**"],
            dependencies: [
                
            ]
        ),
        .target(
            name: "Repository",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.Data.Repository",
            sources: ["Repository/Sources/**"],
            resources: ["Repository/Resources/**"],
            dependencies: [
                .target(name: "DataSource"),
                
                .project(target: "Domain", path: "../Domain"),
                .project(target: "CoreUtil", path: "../Utils/CoreUtil"),
            ]
        ),
        .target(
            name: "DataTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.Data.DataTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "Repository")]
        ),
    ]
)
