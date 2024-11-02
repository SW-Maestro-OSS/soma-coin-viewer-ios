//
//  WebSocketService.swift
//  DataSource
//
//  Created by choijunios on 9/26/24.
//

import Foundation

import CoreUtil


import SwiftStructures

// MARK: Interface
public protocol WebSocketService {
    
    typealias MessageCallback = (URLSessionWebSocketTask.Message) -> Void
    typealias Callback = (Error?) -> Void
    
    /// 웹소켓을 연결합니다.
    func connect(to: URL, connectionCallback: Callback?)
    
    /// 특정 스트림을 구독합니다.
    func subsribe(id: Int64, to: String, subCallback: Callback?, onReceive: (MessageCallback)?)
    
    /// 특정 스트림으로 부터 구독을 해제합니다.
    func unsubscribe(id: Int64, from: [String], unsubCallback: Callback?)
    
    /// 연결을 해제합니다.
    func disconnect()
}

// MARK: Concrete
public class DefaultWebSocketService: NSObject, WebSocketService {
    
    private(set) var session: URLSession!
    
    public private(set) var task: URLSessionWebSocketTask?
    public private(set) var messageCallbacks: LockedDictionary<String, MessageCallback> = .init()
    public private(set) var connectionCallback: Callback?
    
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()
    
    private var pingPongTimer: Timer?
    
    public override init() {
        
        super.init()
        
        // URLSession
        let sessionQueue = OperationQueue()
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: sessionQueue)
    }
    
    private func startTimer() {
        
        pingPongTimer?.invalidate()
        
        pingPongTimer = Timer.scheduledTimer(withTimeInterval: 180, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            
            sendPing()
        })
        
        RunLoop.current.add(pingPongTimer!, forMode: .common)
    }
    
    private func sendPing() {
        
        task?.sendPing(pongReceiveHandler: { error in
            if let error {
                printIfDebug("Pong수신 실패 \(error.localizedDescription)")
            } else {
                printIfDebug("Pong 수신")
            }
        })
    }
    
    public func connect(to baseURL: URL, connectionCallback: Callback?) {
        
        if task != nil { return }
        
        self.connectionCallback = connectionCallback
        
        self.task = session.webSocketTask(with: baseURL)
        self.task?.resume()
        
        // start ping pong
        startTimer()
    }
    
    public func subsribe(id: Int64 = 1, to stream: String, subCallback: Callback?, onReceive: (MessageCallback)?) {
        
        guard let task else { return }
        
        let dto = StreamSubDTO(
            method: .SUBSCRIBE,
            params: [stream],
            id: id
        )
        
        let jsonData = try! jsonEncoder.encode(dto)
        let stringMessage = String(data: jsonData, encoding: .utf8)!
        
        task.send(.string(stringMessage)) { [weak self] error in
            
            subCallback?(error)
            
            if error == nil {
                
                // 매세지 수신 성공 후 컬백등록
                self?.messageCallbacks[stream] = onReceive
            }
        }
    }
    
    public func unsubscribe(id: Int64 = 1, from streams: [String], unsubCallback: Callback?) {
        
        guard let task else { return }
        
        let dto = StreamSubDTO(
            method: .UNSUBSCRIBE,
            params: streams,
            id: id
        )
        
        let jsonData = try! jsonEncoder.encode(dto)
        let stringMessage = String(data: jsonData, encoding: .utf8)!
        
        task.send(.string(stringMessage)) { [weak self] error in
            
            unsubCallback?(error)
            
            if error == nil {
                
                for stream in streams {
                    self?.messageCallbacks.remove(key: stream)
                }
            }
        }
    }
    
    public func disconnect() {
        pingPongTimer?.invalidate()
        task?.cancel(with: .normalClosure, reason: nil)
    }
    
    private func receive() {
        
        task?.receive(completionHandler: { [weak self] result in
            
            guard let self else { return }
            
            switch result {
            case .success(let message):
                
                // callback함수들을 순차적으로 실행
                for callback in self.messageCallbacks.values {
                    
                    callback(message)
                }
                
            case .failure(let error):
                
                self.connectionCallback?(error)
                
                if let urlError = error as? URLError, urlError.code == .cancelled {
                    
                    // 테스크 연결해제시(disconnect) 수신을 재개하지 않고 종료
                    
                    return
                }
            }
            
            // 재귀호출
            self.receive()
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

