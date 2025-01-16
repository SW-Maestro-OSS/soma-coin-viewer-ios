//
//  StubWebSocketHelper.swift
//
//

import Combine

import WebSocketManagementHelper
import BaseFeature

import Swinject


public class StubWebSocketHelper: WebSocketManagementHelper {
    
    public init() { }
    
    public var isWebSocketConnected: AnyPublisher<Bool, Never> = Just(false).eraseToAnyPublisher()
    
    public func requestSubscribeToStream(streams: [String]) {
        
    }
    
    public func requestUnsubscribeToStream(streams: [String]) {
        
    }
    
    public func requestDisconnection() {
        
    }
    
    public func requestConnection(connectionType: ConnectionType) {
        
    }
}
