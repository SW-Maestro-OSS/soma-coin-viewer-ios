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
                D.Feature.RootFeatureInterface,
                
                D.Feature.AllMarketTickerFeature,
                D.Feature.AllMarketTickerFeatureInterface,
                
                D.Feature.SettingFeature,
                D.Feature.SettingFeatureInterface,
                
                D.Feature.BaseFeature,
                D.Feature.BaseFeatureInterface,
                
                
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
                D.Shared.WebSocketManagementHelperInterface,
            ]
        ),
    ]
)

