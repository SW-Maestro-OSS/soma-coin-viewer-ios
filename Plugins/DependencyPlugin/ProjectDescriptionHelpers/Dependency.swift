//
//  Dependency.swift
//  DependencyPlugin
//
//  Created by 최준영 on 9/26/24.
//

@preconcurrency import ProjectDescription
import Foundation

public typealias D = ModuleDependency

public enum ModuleDependency {
    
    public enum App {
    }
    
    public enum Domain {
        public static let interface: TargetDependency = .project(target: "DomainInterface", path: .relativeToRoot("Projects/Domain"))
        public static let concrete: TargetDependency = .project(target: "Domain", path: .relativeToRoot("Projects/Domain"))
    }
    
    public enum Data {
        public static let repository: TargetDependency = .project(target: "Repository", path: .relativeToRoot("Projects/Data"))
        public static let dataSource: TargetDependency = .project(target: "DataSource", path: .relativeToRoot("Projects/Data"))
    }
    
    public enum Feature {
        
        public static let AllMarketTickerFeature: TargetDependency = .project(target: "AllMarketTickerFeature", path: .relativeToRoot("Projects/Features/AllMarketTicker"))
        
    
        public static let BaseFeature: TargetDependency = .project(target: "BaseFeature", path: .relativeToRoot("Projects/Features/Base"))
        
        
        public static let RootFeature: TargetDependency = .project(target: "RootFeature", path: .relativeToRoot("Projects/Features/Root"))
        
        
        public static let SettingFeature: TargetDependency = .project(target: "SettingFeature", path: .relativeToRoot("Projects/Features/Setting"))
        
        public static let CoinDetailFeature: TargetDependency = .project(target: "CoinDetailFeature", path: .relativeToRoot("Projects/Features/CoinDetail"))
    }
    
    public enum Shared {
        
        public static let CommonUI: TargetDependency = .project(target: "CommonUI", path: .relativeToRoot("Projects/Shared/DSKit"))
        
        public static let WebSocketManagementHelper: TargetDependency = .project(target: "WebSocketManagementHelper", path: .relativeToRoot("Projects/Shared/WebSocketManagementHelper"))
        
        public static let I18N: TargetDependency = .project(target: "I18N", path: .relativeToRoot("Projects/Shared/I18N"))
        
        public static let AlertShooter: TargetDependency = .project(target: "AlertShooter", path: .relativeToRoot("Projects/Shared/AlertShooter"))
    }
    
    public enum Util {
        public static let CoreUtil: TargetDependency = .project(target: "CoreUtil", path: .relativeToRoot("Projects/Utils/CoreUtil"))
    }
}

// External dependencies
public extension ModuleDependency {
    
    enum ThirdParty {
        public static let Swinject: TargetDependency = .external(name: "Swinject")
        public static let SimpleImageProvider: TargetDependency = .external(name: "SimpleImageProvider")
        public static let AdvancedSwift: TargetDependency = .external(name: "AdvancedSwift")
    }
}

