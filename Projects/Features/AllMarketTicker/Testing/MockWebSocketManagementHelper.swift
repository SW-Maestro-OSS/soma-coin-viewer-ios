//
//  MockWebSocketManagementHelper.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 4/22/25.
//

import Combine

import WebSocketManagementHelper

class MockWebSocketManagementHelper: WebSocketManagementHelper {
    func requestSubscribeToStream(streams: [WebSocketStream], mustDeliver: Bool) { }
    func requestUnsubscribeToStream(streams: [WebSocketStream], mustDeliver: Bool) { }
    func requestDisconnection() { }
    func requestConnection(connectionType: ConnectionType) { }
}
