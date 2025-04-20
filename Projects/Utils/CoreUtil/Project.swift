import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "CoreUtil",
    targets: [
        .target(
            name: "CoreUtil",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.Utils.CoreUtil",
            sources: ["Sources/**"],
            dependencies: [
                // Third Party
                D.ThirdParty.Swinject,
                D.ThirdParty.AdvancedSwift,
            ]
        ),
    ]
)


