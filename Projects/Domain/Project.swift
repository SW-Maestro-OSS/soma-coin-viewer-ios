import ProjectDescription
import DependencyPlugin

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
            sources: ["Concrete/**"],
            dependencies: [
                .target(name: "DomainInterface"),
                
                D.Util.CoreUtil,
                
                D.Shared.WebSocketManagementHelper,
            ]
        ),
        
        
        .target(
            name: "DomainInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.Domain.interface",
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

