//
//  WebSocketError.swift
//  Data
//
//  Created by choijunios on 12/4/24.
//

import Foundation

public enum WebSocketError: Error {
    /// 의도치 않은 웹소켓 연결 실패
    case unintentionalDisconnection(error: Error?)
    
    /// 스트림 구독 메세지 전송 실패
    case messageTransferFailed(error: Error?)
    
    /// 인터넷 연결 에러
    case internetConnectionError(error: Error?)
    
    /// 웹소켓 서버 에러
    case serverIsBusy
    
    /// 너무 많은 요청 에러
    case tooManyRequests
    
    /// 알 수 없는 에러
    case unknown(error: Error?)
}
