import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Data",
    targets: [
        
        .target(
            name: "Repository",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.CoinViewer.Data.Repository",
            sources: ["Repository/Sources/**"],
            resources: ["Repository/Resources/**"],
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
            sources: ["DataSource/Sources/**"],
            resources: ["DataSource/Resources/**"],
            dependencies: [
                D.Util.CoreUtil,
                
                // external
                ModuleDependency.ThirdParty.SwiftStructures,
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
