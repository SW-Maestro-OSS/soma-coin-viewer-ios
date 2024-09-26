//
//  DataAssembly.swift
//  CoinViewer
//
//  Created by choijunios on 9/26/24.
//

import Foundation
import Repository
import Domain
import PresentationUtil


import Swinject

public class DataAssembly: Assembly {
    
    public func assemble(container: Swinject.Container) {
        
        // MARK: Repository
        container.register(TestRepository.self) { _ in
            DefaultTestRepository()
        }
    }
    
}
