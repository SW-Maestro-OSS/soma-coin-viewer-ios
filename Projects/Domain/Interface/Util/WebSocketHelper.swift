//
//  WebSocketHelper.swift
//  Domain
//
//  Created by choijunios on 11/2/24.
//

public protocol WebSocketHelper {
    
    /// 웹소켓에 연결합니다.
    func connect(completion: @escaping ((any Error)?) -> ())
    
    /// 웹소켓 연결을 종료합니다.
    func disconnect()
}
