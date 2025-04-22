import ProjectDescription
import DependencyPlugin
import ConfigurationPlugin

let project = Project(
    name: "CoreUtil",
    targets: [
        .target(
            name: "CoreUtil",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.Utils.CoreUtil",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Sources/**"],
            dependencies: [
                // Third Party
                D.ThirdParty.Swinject,
                D.ThirdParty.AdvancedSwift,
            ]
        ),
    ]
)


