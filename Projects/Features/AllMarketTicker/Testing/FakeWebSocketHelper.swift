//
//  FakeWebSocketHelper.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/13/25.
//

import Combine

import WebSocketManagementHelper

class FakeWebSocketHelper: WebSocketManagementHelper {
    
    init() { }
    
    var isWebSocketConnected: AnyPublisher<Bool, Never> = Just(false).eraseToAnyPublisher()
    
    func requestSubscribeToStream(streams: [String]) {
        
    }
    
    func requestUnsubscribeToStream(streams: [String]) {
        
    }
    
    func requestDisconnection() {
        
    }
    
    func requestConnection(connectionType: ConnectionType) {
        
    }
}
