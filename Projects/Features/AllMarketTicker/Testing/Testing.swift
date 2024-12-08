//
//  Testing.swift
//
//

import Foundation
import Combine

import WebSocketManagementHelperInterface
import DomainInterface

@testable import AllMarketTickerFeature

struct TestSortComparator: TickerSortComparator {
    
    var id: String = "test-comparator"
    
    func compare(lhs: TickerVO, rhs: TickerVO) -> Bool {
        
        lhs.price < rhs.price
    }
}

class MockAllMarketTickersUseCase: AllMarketTickersUseCase {
    func requestTickers() -> AnyPublisher<[DomainInterface.Twenty4HourTickerForSymbolVO], Never> {
        
        Just([]).eraseToAnyPublisher()
    }
}

class MockWebSocketHelper: WebSocketManagementHelper {
    
    var isWebSocketConnected: AnyPublisher<Bool, Never> = Just(false).eraseToAnyPublisher()
    
    func requestSubscribeToStream(streams: [String]) {
        
    }
    
    func requestUnsubscribeToStream(streams: [String]) {
        
    }
    
    func requestDisconnection() {
        
    }
    
    func requestConnection(connectionType: WebSocketManagementHelperInterface.ConnectionType) {
        
    }
}
