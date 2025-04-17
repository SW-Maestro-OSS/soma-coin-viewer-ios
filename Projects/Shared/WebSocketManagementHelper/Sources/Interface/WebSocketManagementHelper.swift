//
//  WebSocketManagementHelper.swift
//
//

import Combine

public protocol WebSocketManagementHelper {
    
    /// 웹소켓 연결 상태를 퍼블리싱 합니다.
    var isWebSocketConnected: AnyPublisher<Bool, Never> { get }
    
    
    /// 스트림 연결을 요청합니다.
    ///
    /// 이 메서드는 서버와의 스트림 연결을 시작합니다.
    /// `autoReconnectionEnabled`가 `true`로 설정된 경우,
    /// 애플리케이션이 백그라운드 상태에서 포그라운드로 전환될 때
    /// 스트림이 자동으로 재연결됩니다.
    ///
    /// - Parameter autoReconnectionEnabled: 앱이 포그라운드로 전환될 때 스트림을 자동으로 재연결할지 여부입니다.
    func requestSubscribeToStream(streams: [String], autoReconnectionEnabled: Bool)
    
    
    /// 스트림 연결을 끊을 것을 요청합니다.
    func requestUnsubscribeToStream(streams: [String])
    
    
    /// 소켓을 연결을 종료할 것을 요청합니다.
    func requestDisconnection()
    
    
    /// 소켓을 연결할 것을 요청합니다.
    func requestConnection(connectionType: ConnectionType)
}
