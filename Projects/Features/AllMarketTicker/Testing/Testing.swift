//
//  Testing.swift
//
//

import Foundation
import Combine

import AllMarketTickerFeature

import WebSocketManagementHelperInterface
import DomainInterface

public struct TestSortComparator: TickerSortComparator {
    
    public var id: String
    
    public init(id: String = "test-comparator") {
        self.id = id
    }
    
    public func compare(lhs: TickerVO, rhs: TickerVO) -> Bool {
        
        lhs.price < rhs.price
    }
}

public class MockAllMarketTickersUseCase: AllMarketTickersUseCase {
    
    public init() { }
    
    public func requestTickers() -> AnyPublisher<[DomainInterface.Twenty4HourTickerForSymbolVO], Never> {
        
        Just([]).eraseToAnyPublisher()
    }
}

public class MockWebSocketHelper: WebSocketManagementHelper {
    
    public init() { }
    
    public var isWebSocketConnected: AnyPublisher<Bool, Never> = Just(false).eraseToAnyPublisher()
    
    public func requestSubscribeToStream(streams: [String]) {
        
    }
    
    public func requestUnsubscribeToStream(streams: [String]) {
        
    }
    
    public func requestDisconnection() {
        
    }
    
    public func requestConnection(connectionType: WebSocketManagementHelperInterface.ConnectionType) {
        
    }
}
