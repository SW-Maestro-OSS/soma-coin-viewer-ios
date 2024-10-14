import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "DSKit",
    options: .options(
        // Localization
        defaultKnownRegions: ["en", "ko"],
        developmentRegion: "ko"
    ),
    packages: [
        .local(path: .relativeToRoot("LocalPackage/Macro/LocalizableMacro"))
    ],
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
                .package(product: "LocalizableMacro", type: .macro),
            ]
        )
    ]
)

