//
//  AllMarketTickerTests.swift
//  DomainTests
//
//  Created by choijunios on 11/2/24.
//

import Testing
import Foundation
import Combine

import DomainInterface
import Domain
import CoreUtil

import DomainTesting


struct AllMarketTickerUseCaseTests {
    
    let allMarketTickersUseCase: DefaultAllMarketTickersUseCase
    
    init() {
        
        /// 테스트 레포지토리는 "symbol+index"이름을 가지는 정보들을 반환합니다.
        /// index의 범위는 0..<100입니다.
        /// 해당 레퍼지토리가 반환하는 데이터의 프로퍼티 값은 인덱스에 비례합니다.
        DependencyInjector.shared.register(AllMarketTickersRepository.self, MockAllMarketTickersRepository())
        
        self.allMarketTickersUseCase = .init()
    }
    
    @Test
    func fromTheBeginTest() async {
        
        for await list in allMarketTickersUseCase
            .requestTickers(
                maxCount: 5,
                cuttingStyle: .begining,
                sortOperator: {
                    $0.price < $1.price
                }
            ).values {
            
            let symbols = list.map({ $0.symbol })
            
            #expect(symbols == ["symbol0", "symbol1", "symbol2", "symbol3", "symbol4"])
        }
    }
    
    
    @Test
    func fromTheEndTest() async {
        
        for await list in allMarketTickersUseCase
            .requestTickers(
                maxCount: 5,
                cuttingStyle: .end,
                sortOperator: {
                    $0.price < $1.price
                }
            ).values {
            
            let symbols = list.map({ $0.symbol })
            
            #expect(symbols == ["symbol95", "symbol96", "symbol97", "symbol98", "symbol99"])
        }
    }
}
