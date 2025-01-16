// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
        productTypes: [
            "SwiftStructures": .framework,
            "SimpleImageProvider": .framework,
        ]
    )
#endif

let packagePath: String = "LocalPackage"

let package = Package(
    name: "CoinViewer",
    dependencies: [
        
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
        .package(url: "https://github.com/J0onYEong/SwiftStructures.git", exact: "1.0.4"),
        .package(url: "https://github.com/J0onYEong/SimpleImageProvider.git", from: "1.0.3"),
    ]
)
