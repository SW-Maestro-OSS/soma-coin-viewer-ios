import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "DSKit",
    targets: [
        .target(
            name: "CommonUI",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.DSKit.CommonUI",
            sources: ["./CommonUI/Sources/**"],
            resources: ["./CommonUI/Resources/**"],
            dependencies: [
                D.Util.PresentationUtil,
            ]
        ),
    ]
)

