//
//  Dependency.swift
//  DependencyPlugin
//
//  Created by 최준영 on 9/26/24.
//

import ProjectDescription
import Foundation

public typealias D = ModuleDependency

public enum ModuleDependency {
    
    public enum App {
    }
    
    public enum Domain {
    }
    
    public enum Data {
    }
    
    public enum Presentation {
    }
}

// External dependencies
public extension ModuleDependency {
    
    enum ThirdParty {
        public static let Swinject: TargetDependency = .external(name: "Swinject")
        public static let SwiftStructures: TargetDependency = .external(name: "SwiftStructures")
    }
}

