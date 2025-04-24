//
//  MockWebSocketManagementHelper.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 4/22/25.
//

import Combine

import WebSocketManagementHelper

public final class MockWebSocketManagementHelper: WebSocketManagementHelper {
    
    public init() { }
    
    public func requestSubscribeToStream(streams: [WebSocketStream], mustDeliver: Bool) { }
    public func requestUnsubscribeToStream(streams: [WebSocketStream], mustDeliver: Bool) { }
    public func requestDisconnection() { }
    public func requestConnection(connectionType: ConnectionType) { }
}
