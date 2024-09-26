import ProjectDescription

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
                .target(name: "I18N"),
                .project(target: "PresentationUtil", path: "../Utils/PresentationUtil"),
            ]
        ),
        .target(
            name: "I18N",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.DSKit.I18N",
            sources: ["./I18N/Sources/**"],
            resources: ["./I18N/Resources/**"],
            dependencies: [
               
            ]
        )
    ]
)
