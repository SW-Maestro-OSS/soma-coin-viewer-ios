import ProjectDescription
import DependencyPlugin
import ConfigurationPlugin

let project = Project(
    name: "DSKit",
    targets: [
        .target(
            name: "CommonUI",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.DSKit.CommonUI",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["./CommonUI/Sources/**"],
            resources: ["./CommonUI/Resources/**"],
            dependencies: [ ]
        ),
    ]
)

