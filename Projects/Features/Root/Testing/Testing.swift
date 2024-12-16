//
//  Testing.swift
//
//

import Combine

import WebSocketManagementHelperInterface
import BaseFeatureInterface

import Swinject


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
