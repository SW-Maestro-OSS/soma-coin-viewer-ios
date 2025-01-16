import ProjectDescription
import DependencyPlugin
import ConfigurationPlugin

let project = Project(
    name: "App",
    options: .options(
        
        // Localization
        defaultKnownRegions: ["en", "ko"],
        
        // Default lan
        developmentRegion: "en"
    ),
    targets: [
        .target(
            name: "CoinViewer",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.CoinViewer",
            infoPlist: .main_app,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                
                // Features
                D.Feature.RootFeature,

                // Domain
                D.Domain.concrete,
                D.Domain.interface,
                
                // Data
                D.Data.dataSource,
                D.Data.repository,
                
                // Util
                D.Util.PresentationUtil,
                
                // Shared
                D.Shared.WebSocketManagementHelper,
            ],
            settings: .settings(
                base: [
                    "OPENEX_API_KEY" : "$(inherited)"
                ],
                configurations: [
                    .debug(
                        name: "Debug",
                        xcconfig: .relativeToRoot("Secrets/xcconfigs/Debug.xcconfig")
                    ),
                    .release(
                        name: "Release",
                        xcconfig: .relativeToRoot("Secrets/xcconfigs/Release.xcconfig")
                    )
                ]
            )
        ),
    ]
)

