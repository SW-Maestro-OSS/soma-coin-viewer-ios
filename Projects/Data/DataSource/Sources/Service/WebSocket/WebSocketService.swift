//
//  WebSocketService.swift
//  DataSource
//
//  Created by choijunios on 9/26/24.
//

import Foundation
import Combine

// MARK: Interface
public protocol WebSocketService {
    
    typealias Message = URLSessionWebSocketTask.Message
    typealias Response = Result<Message, Error>
    
    /// 웹소켓 메세지 상태입니다.
    var message: PassthroughSubject<Response, Never> { get }
    
    
    /// 소켓을 연결할 것을 요청합니다.
    func connect()
    
    
    /// 연결된 소켓을 해제할 것을 요청합니다.
    func disconnect()
    
    
    /// 특정 스트림에 구독할 것을 요청합니다.
    func subscribeTo(messageParameters: [String])
    
    
    /// 특정 스트림에 구독을 해제할 것을 요청합니다.
    func unsubscribeTo(messageParameters: [String])
}
