import ProjectDescription
import ConfigurationPlugin
import DependencyPlugin

let project = Project(
    name: "Data",
    targets: [
        .target(
            name: "Repository",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.CoinViewer.Data.Repository",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Repository/**"],
            dependencies: [
                // internal
                .target(name: "DataSource"),
                D.Domain.interface,
            ]
        ),
        
        .target(
            name: "DataSource",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.Data.DataSource",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["DataSource/**"],
            dependencies: [
                D.Util.CoreUtil,
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
            dependencies: [
                .target(name: "Repository"),
            ]
        ),
    ]
)
