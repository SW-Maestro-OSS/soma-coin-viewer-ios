//
//  DataAssembly.swift
//  CoinViewer
//
//  Created by choijunios on 9/26/24.
//

import Foundation

// Domain
import Domain
import DomainInterface

// Data
import Repository
import DataSource

// Utils


import Swinject

public class DataAssembly: Assembly {
    
    public func assemble(container: Swinject.Container) {
        
        
        // MARK: Repository
        container.register(UserConfigurationRepository.self) { _ in
            DefaultUserConfigurationRepository()
        }
        .inObjectScope(.container)
        
        
        
        // MARK: DataSource
        container.register(UserConfigurationService.self) { _ in
            DefaultUserConfigurationService()
        }
    }
}
