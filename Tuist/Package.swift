// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
        productTypes: [:]
    )
#endif

let packagePath: String = "LocalPackage"

let package = Package(
    name: "CoinViewer",
    dependencies: [
        
        // [Service locator] - Swinject
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
    ]
)
