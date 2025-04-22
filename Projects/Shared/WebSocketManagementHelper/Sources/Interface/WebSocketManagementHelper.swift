//
//  WebSocketManagementHelper.swift
//
//

import Combine

public protocol WebSocketManagementHelper {
    /// 스트림 연결을 요청합니다.
    func requestSubscribeToStream(streams: [WebSocketStream], mustDeliver: Bool)
    
    
    /// 스트림 연결을 끊을 것을 요청합니다.
    func requestUnsubscribeToStream(streams: [WebSocketStream], mustDeliver: Bool)
    
    
    /// 소켓을 연결을 종료할 것을 요청합니다.
    func requestDisconnection()
    
    
    /// 소켓을 연결할 것을 요청합니다.
    func requestConnection(connectionType: ConnectionType)
}
