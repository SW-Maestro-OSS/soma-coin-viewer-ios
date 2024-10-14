import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "I18N",
    options: .options(
        // Localization
        defaultKnownRegions: ["en", "ko"],
        developmentRegion: "ko",
        disableSynthesizedResourceAccessors: true
    ),
    packages: [
        .local(path: .relativeToRoot("LocalPackage/Macro/LocalizableMacro"))
    ],
    targets: [
        .target(
            name: "I18N",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.CoinViewer.I18N",
            sources: ["./Sources/**"],
            resources: ["./Resources/**",],
            dependencies: [
                .package(product: "LocalizableMacro", type: .macro),
            ]
        ),
    ]
)

