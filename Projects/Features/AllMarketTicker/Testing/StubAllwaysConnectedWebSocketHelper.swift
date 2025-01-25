//
//  StubAllwaysConnectedWebSocketHelper.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/13/25.
//

import Combine

import WebSocketManagementHelper

class StubAllwaysConnectedWebSocketHelper: WebSocketManagementHelper {
    
    var isWebSocketConnected: AnyPublisher<Bool, Never> = Just(true).eraseToAnyPublisher()
    
    init() { }
    
    func requestSubscribeToStream(streams: [String]) {
        
    }
    
    func requestUnsubscribeToStream(streams: [String]) {
        
    }
    
    func requestDisconnection() {
        
    }
    
    func requestConnection(connectionType: ConnectionType) {
        
    }
}

