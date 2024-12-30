//
//  DomainAssembly.swift
//  CoinViewer
//
//  Created by choijunios on 11/2/24.
//

import Repository
import DomainInterface
import Domain

import Swinject

class DomainAssembly: Assembly {
    
    func assemble(container: Swinject.Container) {
        
        // UseCase
        container.register(AllMarketTickersUseCase.self) { _ in
            DefaultAllMarketTickersUseCase()
        }
        
        container.register(PriceUseCase.self) { _ in
            DefaultPriceUseCase()
        }
    }
}
