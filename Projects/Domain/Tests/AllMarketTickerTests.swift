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

struct AllMarketTickerPageUseCase {
    
    let useCase: DefaultAllMarketTickerPageUseCase
    var store: Set<AnyCancellable> = .init()
    
    init() {
        
        DependencyInjector.shared.register((any AllMarketTickerRepository).self, MockAllMarketTickersRepository())
        
        self.useCase = .init()
    }
    
    
    @Test func top30Items_AfterSorting() async {

        for await originalList in useCase.getList(count: 30).values {
            
            #expect(originalList.count == 30)
            
            let sorted = Array(originalList.sorted { lhs, rhs in
                lhs.totalTradedQuoteAssetVolume > rhs.totalTradedQuoteAssetVolume
            })
            
            #expect(sorted == originalList)
        }
    }
}

extension Symbol24hTickerVO: @retroactive Equatable {
    public static func == (lhs: Symbol24hTickerVO, rhs: Symbol24hTickerVO) -> Bool {
        lhs.symbol == rhs.symbol
    }
}
