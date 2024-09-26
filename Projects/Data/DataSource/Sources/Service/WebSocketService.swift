//
//  WebSocketService.swift
//  DataSource
//
//  Created by choijunios on 9/26/24.
//

import Foundation
import CoreUtil

// MARK: Interface
public protocol WebSocketService {
    
    /// 웹소켓을 연결합니다.
    func connect(to: URL, streams: [String], completion: ((Data) -> Void)?)
    
    /// 특정 스트림들을 구독합니다.
    func subsribe(to: [String])
    
    /// 특정 스트림들로 부터 구독을 해제합니다.
    func unsubscribe(from: [String])
    
    /// 연결을 해제합니다.
    func disconnect(from: URL)
}

// MARK: Concrete
public class DefaultWebSocketService: NSObject, WebSocketService {
    
    var task: URLSessionWebSocketTask?
    
    public func connect(to: URL, streams: [String], completion: ((Data) -> Void)?) {
        
        if task != nil { return }
    }
    
    public func subsribe(to: [String]) {
        
    }
    
    public func unsubscribe(from: [String]) {
        
    }
    
    public func disconnect(from: URL) {
        
    }
}

extension DefaultWebSocketService: URLSessionWebSocketDelegate {
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        
        printIfDebug("✅ 웹소캣 열림")
    }
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        
        printIfDebug("☑️ 웹소캣 닫침")
    }
}

