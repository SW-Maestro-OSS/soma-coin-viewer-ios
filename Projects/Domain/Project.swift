import ProjectDescription
import DependencyPlugin
import ConfigurationPlugin

let project = Project(
    name: "Domain",
    targets: [
        .target(
            name: "DomainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.CoinViewer.Domain.tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "DomainTesting"),
            ]
        ),
        
        
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.CoinViewer.Domain",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Concrete/**"],
            dependencies: [
                .target(name: "DomainInterface"),
            ]
        ),
        
        
        .target(
            name: "DomainInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.Domain.interface",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Interface/**"],
            dependencies: [
                D.Util.CoreUtil,
            ]
        ),
        
        
        .target(
            name: "DomainTesting",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.CoinViewer.Domain.testing",
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "DomainInterface"),
            ]
        ),   
    ]
)

