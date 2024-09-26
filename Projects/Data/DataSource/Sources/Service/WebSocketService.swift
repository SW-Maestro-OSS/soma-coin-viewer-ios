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
    
    typealias Callback = (URLSessionWebSocketTask.Message) -> Void
    
    /// 웹소켓을 연결합니다.
    func connect(to: URL, streams: [String], completion: (Callback)?)
    
    /// 특정 스트림들을 구독합니다.
    func subsribe(to: [String])
    
    /// 특정 스트림들로 부터 구독을 해제합니다.
    func unsubscribe(from: [String])
    
    /// 연결을 해제합니다.
    func disconnect()
}

// MARK: Concrete
public class DefaultWebSocketService: NSObject, WebSocketService {
    
    private(set) var session: URLSession!
    
    public private(set) var task: URLSessionWebSocketTask?
    public private(set) var callback: Callback?
    
    public override init() {
        
        super.init()
        
        // URLSession
        let sessionQueue = OperationQueue()
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: sessionQueue)
    }
    
    public func connect(to baseURL: URL, streams: [String], completion: (Callback)?) {
        
        if task != nil { return }
        
        var urlWithStream = baseURL
        let streamQueryValue = streams.joined(separator: "/")
        
        urlWithStream.append(queryItems: [
            .init(name: "streams", value: streamQueryValue)
        ])
        
        self.callback = completion
        self.task = session.webSocketTask(with: urlWithStream)
        self.task?.resume()
    }
    
    public func subsribe(to streams: [String]) {
        
    }
    
    public func unsubscribe(from streams: [String]) {
        
    }
    
    public func disconnect() {
        task?.cancel(with: .normalClosure, reason: nil)
    }
    
    private func receive() {
        
        task?.receive(completionHandler: { [weak self] result in
            
            switch result {
            case .success(let message):
                
                self?.callback?(message)
                
            case .failure(let failure):
                
                if let urlError = failure as? URLError, urlError.code == .cancelled {
                    
                    // 테스크 연결해제시(disconnect) 수신을 재개하지 않고 종료
                    return
                }
            }
            
            // 재귀호출
            self?.receive()
        })
    }
}

extension DefaultWebSocketService: URLSessionWebSocketDelegate {
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        
        printIfDebug("✅ 웹소캣 열림")
        
        // 메세지 수신 시작
        receive()
    }
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        
        printIfDebug("☑️ 웹소캣 닫침")
    }
}

