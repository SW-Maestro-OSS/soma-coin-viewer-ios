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
        
        // 구현자체는 데이터 레이에 구현되어 있다. 추후 별도의 모듈로 분리 예정
        container.register(WebSocketHelper.self) { _ in
            DefaultWebSockerHelper()
        }
        
        // UseCase
    }
}
