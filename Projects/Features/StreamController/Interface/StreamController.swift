//
//  StreamController.swift
//  StreamControllerModule
//
//  Created by choijunios on 11/15/24.
//

public protocol StreamController {
    
    /// 스트림 연결을 요청합니다.
    func requestSubscribeToStream(streams: [String])
    
    
    /// 스트림 연결을 끊을 것을 요청합니다.
    func requestUnsubscribeToStream(streams: [String])
}
