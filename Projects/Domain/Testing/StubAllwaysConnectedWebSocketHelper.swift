//
//  StubAllwaysConnectedWebSocketHelper.swift
//  Domain
//
//  Created by choijunios on 1/25/25.
//

import Combine

import WebSocketManagementHelper

class StubAllwaysConnectedWebSocketHelper: WebSocketManagementHelper {
    
    var isWebSocketConnected: AnyPublisher<Bool, Never> = Just(true).eraseToAnyPublisher()
    
    init() { }
    
    func requestSubscribeToStream(streams: [String], mustDeliver: Bool) { }
    func requestUnsubscribeToStream(streams: [String], mustDeliver: Bool) { }
    func requestDisconnection() { }
    func requestConnection(connectionType: ConnectionType) { }
}
