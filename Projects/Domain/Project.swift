import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Domain",
    targets: [
        
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.Domain",
            sources: ["Concrete/**"],
            dependencies: [
                .target(name: "DomainInterface"),
                
                D.Util.CoreUtil,
            ]
        ),
        
        
        .target(
            name: "DomainInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.Domain",
            sources: ["Interface/**"],
            dependencies: [
                
            ]
        ),
        
        
        .target(
            name: "DomainTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.Domain",
            sources: ["Interface/**"],
            dependencies: [
                .target(name: "DomainInterface"),
            ]
        ),
        
        
        .target(
            name: "DomainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.DomainTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "DomainTesting"),
            ]
        ),
    ]
)

