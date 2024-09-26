import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "PresentationUtil",
    targets: [
        .target(
            name: "PresentationUtil",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.Utils.PresentationUtil",
            sources: ["Sources/**"],
            dependencies: [
                // Modules in app
                .project(target: "CoreUtil", path: "../CoreUtil"),
                
                // Third Party
                D.ThirdParty.Swinject,
            ]
        ),
    ]
)


