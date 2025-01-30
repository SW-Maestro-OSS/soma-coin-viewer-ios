//
//  WebSocketService.swift
//  DataSource
//
//  Created by choijunios on 9/26/24.
//

import Foundation
import Combine

public protocol WebSocketServiceListener: AnyObject {
    
    func webSocketListener(unrelatedError: WebSocketError)
}


public protocol WebSocketService {
    
    typealias WebsocketCompletion = (Result<Void, WebSocketError>) -> Void
    
    // Listener
    var listener: WebSocketServiceListener? { get }
    
    
    /// 전달한 매세지 형태와 일치하는 메세지만을 리턴합니다. 에러가 전달되지 않습니다.
    func getMessageStream<DTO: Decodable>() -> AnyPublisher<DTO, Never>
    
    
    /// 소켓을 연결할 것을 요청합니다.
    func connect(completion: @escaping WebsocketCompletion)
    
    
    /// 연결된 소켓을 해제할 것을 요청합니다.
    func disconnect()
    
    
    /// 특정 스트림에 구독할 것을 요청합니다.
    func subscribeTo(message: [String], completion: @escaping WebsocketCompletion)
    
    
    /// 특정 스트림에 구독을 해제할 것을 요청합니다.
    func unsubscribeTo(message: [String], completion: @escaping WebsocketCompletion)
}
