//
//  BinanceWebSocketService.swift
//  Data
//
//  Created by choijunios on 11/11/24.
//

import Foundation
import Combine

import CoreUtil

public class BinanceWebSocketService: NSObject, WebSocketService {
    
    static let baseURL: URL = .init(string: "wss://stream.binance.com:443/ws")!
    
    private let socketMessagePublisher: PassthroughSubject<Response, Never> = .init()
    
    public let message: AnyPublisher<Response, Never>
    
    
    // Network
    private let webSocketManagementQueue: DispatchQueue = .init(label: "com.webSocket.management")
    private var webSocketSession: URLSession!
    private var webSocketTask: URLSessionWebSocketTask?
    private var timerForHeartbeat: DispatchSourceTimer?
    private let heartbeatTimerQueue: DispatchQueue = .init(label: "com.heartbeat")
    
    private let jsonEncoder = JSONEncoder()
    
    public override init() {
        
        self.message = socketMessagePublisher
            .share()
            .eraseToAnyPublisher()
        
        super.init()
        
        let sessionQueue = OperationQueue()
        self.webSocketSession = URLSession(configuration: .default, delegate: self, delegateQueue: sessionQueue)
    }
    
    private var isConnected: Bool {
        
        webSocketTask != nil && webSocketTask?.state == .running
    }
    
    public func connect() {
        
        webSocketManagementQueue.async { [weak self] in
            
            guard let self else { return }
            
            // 웹소켓 연결여부 확인
            if isConnected { return }
            
            self.webSocketTask = webSocketSession.webSocketTask(with: Self.baseURL)
            self.webSocketTask?.resume()
            
            startHeartbeating()
        }
    }
    
    public func disconnect() {
        
        webSocketManagementQueue.async { [weak self] in
            
            guard let self else { return }
            
            // 하트비트 종료
            timerForHeartbeat?.cancel()
            timerForHeartbeat = nil
            
            
            // 웹소켓 연결 종료
            webSocketTask?.cancel(with: .normalClosure, reason: nil)
        }
    }
    
    public func subscribeTo(messageParameters: [String]) {
        
        webSocketManagementQueue.async { [weak self] in
            
            guard let self else { return }
            
            let messageDTO = BinanceWebSocketStreamMessageDTO(
                method: .SUBSCRIBE,
                params: messageParameters,
                id: 1
            )
            
            sendMessage(messageDTO)
        }
    }
    
    public func unsubscribeTo(messageParameters: [String]) {
        
        webSocketManagementQueue.async { [weak self] in
            
            guard let self else { return }
            
            let messageDTO = BinanceWebSocketStreamMessageDTO(
                method: .UNSUBSCRIBE,
                params: messageParameters,
                id: 1
            )
            
            sendMessage(messageDTO)
        }
    }
    
    private func sendMessage(_ message: BinanceWebSocketStreamMessageDTO) {
        
        let jsonData = try! jsonEncoder.encode(message)
        let stringedMessage = String(data: jsonData, encoding: .utf8)!
        
        webSocketTask?.send(.string(stringedMessage)) { error in
            
            if let error {
                
                printIfDebug("웹소켓 메시지 전송실패 \(error.localizedDescription)")
            }
        }
    }
}

// MARK: Recieve message from socket
extension BinanceWebSocketService: URLSessionWebSocketDelegate {
    
    private func listenToMessage() {
        
        webSocketTask?.receive(completionHandler: { [weak self] result in
            
            guard let self else { return }
            
            socketMessagePublisher.send(result)
            
            // 재귀호출
            listenToMessage()
        })
    }
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        
        printIfDebug("✅ 웹소캣 연결됨")
        
        listenToMessage()
    }
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        
        printIfDebug("☑️ 웹소캣 연결 끊김")
    }
}


// MARK: Socket heart beat
extension BinanceWebSocketService {
    
    private func sendHeartbeatMessage() {
        
        webSocketTask?.sendPing(pongReceiveHandler: { error in
            if let error {
                printIfDebug("Pong수신 실패 \(error.localizedDescription)")
            } else {
                printIfDebug("Pong 수신")
            }
        })
    }
    
    private func startHeartbeating() {
        
        timerForHeartbeat?.cancel()
        
        
        // DispatchSourceTimer 초기화
        let scheduledTimer = DispatchSource.makeTimerSource(queue: heartbeatTimerQueue)
        
        // 3분에 한번씩 하트비트 유지 메세지 전송
        scheduledTimer.schedule(deadline: .now(), repeating: 180)
        
        scheduledTimer.setEventHandler { [weak self] in
            
            self?.sendHeartbeatMessage()
        }
                
        // 타이머 시작
        scheduledTimer.resume()
        
        self.timerForHeartbeat = scheduledTimer
    }
}


// MARK: Native types
extension BinanceWebSocketService {
    
    struct BinanceWebSocketStreamMessageDTO: Codable {
        
        enum Method: String, Codable {
            case SUBSCRIBE
            case UNSUBSCRIBE
        }
        
        let method: Method
        let params: [String]
        let id: Int64
        
        init(
            method: Method,
            params: [String],
            id: Int64
        ) {
            self.method = method
            self.params = params
            self.id = id
        }
    }

}
