//
//  BinanceWebSocketService.swift
//  Data
//
//  Created by choijunios on 11/11/24.
//

import Foundation
import Combine

import CoreUtil

import SwiftStructures

public class BinanceWebSocketService: NSObject, WebSocketService, URLSessionWebSocketDelegate {
    
    // Public streams
    public let state: AnyPublisher<WebSocketState, Never>
    
    
    // Message decoder
    private let messageDecoder: JSONDecoder = .init()
    
    
    // Internal publishers
    private typealias Message = URLSessionWebSocketTask.Message
    private let webSocketMessagePublisher: PassthroughSubject<Message, Never> = .init()
    private let webSocketStatePublisher: CurrentValueSubject<WebSocketState, Never> = .init(.disconnected)
    
    
    // Network
    private let webSocketManagementQueue: DispatchQueue = .init(label: "com.webSocket.management")
    private var webSocketSession: URLSession!
    private var currentWebSocketTask: URLSessionWebSocketTask?
    private var timerForHeartbeat: DispatchSourceTimer?
    private let heartbeatTimerQueue: DispatchQueue = .init(label: "com.heartbeat")
    
    
    // Connection callback
    private let connectionCompletion: LockedDictionary<Int, WebsocketCompletion> = .init()
    
    
    private let jsonEncoder = JSONEncoder()
    
    static let baseURL: URL = .init(string: "wss://stream.binance.com:443/ws")!
    
    public override init() {
        self.state = webSocketStatePublisher
            .share()
            .eraseToAnyPublisher()
        
        super.init()
        
        let sessionQueue = OperationQueue()
        self.webSocketSession = URLSession(configuration: .default, delegate: self, delegateQueue: sessionQueue)
    }
    
    private var isConnected: Bool {
        
        currentWebSocketTask != nil && currentWebSocketTask?.state == .running
    }
    
    public func subscribeTo(message: [String], completion: @escaping WebsocketCompletion) {
        
        webSocketManagementQueue.async { [weak self] in
            
            guard let self, !message.isEmpty else { return }
            
            let messageDTO = BinanceWebSocketStreamMessageDTO(
                method: .SUBSCRIBE,
                params: message,
                id: 1
            )
            
            sendMessage(messageDTO) { result in
                
                switch result {
                    
                case .success:
                    
                    completion(.success(()))
                    
                case .failure(_):
                    
                    completion(.failure(.messageTransferFailure(message: message)))
                    
                }
            }
        }
    }
    
    public func unsubscribeTo(message: [String], completion: @escaping WebsocketCompletion) {
        
        webSocketManagementQueue.async { [weak self] in
            
            guard let self, !message.isEmpty else { return }
            
            let messageDTO = BinanceWebSocketStreamMessageDTO(
                method: .UNSUBSCRIBE,
                params: message,
                id: 1
            )
            
            sendMessage(messageDTO) { result in
                
                switch result {
                    
                case .success:
                    
                    completion(.success(()))
                    
                case .failure(_):
                    
                    completion(.failure(.messageTransferFailure(message: message)))
                    
                }
            }
        }
    }
    
    private func sendMessage(_ message: BinanceWebSocketStreamMessageDTO, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let jsonData = try! jsonEncoder.encode(message)
        let stringedMessage = String(data: jsonData, encoding: .utf8)!
        
        currentWebSocketTask?.send(.string(stringedMessage)) { error in
            if let error {
                printIfDebug("웹소켓 메시지 전송실패 \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}


// MARK: Message stream
extension BinanceWebSocketService {
    
    public func getMessageStream<DTO>() -> AnyPublisher<DTO, Never> where DTO : Decodable {
        webSocketMessagePublisher
            .unretained(self)
            .compactMap { service, message in
                var dataMsg: Data!
                switch message {
                case .string(let strMsg):
                    guard let data = strMsg.data(using: .utf8) else { break }
                    dataMsg = data
                case .data(let data):
                    dataMsg = data
                @unknown default:
                    fatalError()
                }
                guard let decoded = try? service.messageDecoder.decode(DTO.self, from: dataMsg) else { return nil }
                return decoded
            }
            .eraseToAnyPublisher()
    }
}


// MARK: WebSocket connection
extension BinanceWebSocketService {
    
    public func connect(completion: @escaping WebsocketCompletion) {
        
        webSocketManagementQueue.async { [weak self] in
            
            guard let self else { return }
            
            // 웹소켓 연결여부 확인
            if isConnected { return }
            
            let webSocketTask = webSocketSession.webSocketTask(with: Self.baseURL)
            webSocketTask.resume()
            
            // 최초연결 콜백 작업 등록
            let taskId = webSocketTask.taskIdentifier
            connectionCompletion[taskId] = completion
            
            self.currentWebSocketTask = webSocketTask
        }
    }
    
    public func disconnect() {
        
        webSocketManagementQueue.async { [weak self] in
            
            guard let self else { return }
            
            // 하트비트 종료
            timerForHeartbeat?.cancel()
            timerForHeartbeat = nil
            
            
            // 웹소켓 연결 종료
            currentWebSocketTask?.cancel(with: .normalClosure, reason: nil)
        }
    }
}


// MARK: WebSocket Message수신
private extension BinanceWebSocketService {
    
    private func listenToMessage() {
        
        currentWebSocketTask?.receive(completionHandler: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let message):
                // 메세지 정상도착
                webSocketMessagePublisher.send(message)
                listenToMessage()
            case .failure(let error):
                let nsError = error as NSError
                switch nsError.domain {
                case NSPOSIXErrorDomain:
                    // NSPOSIXErrorDomain: 네트워크 소켓 및 저수준 POSIX 관련 에러
                    break
                case NSURLErrorDomain:
                    break
                default:
                    // Unknown error
                    break
                }
                if nsError.domain == NSPOSIXErrorDomain && nsError.code == 57 {
                    // CODE=57, 웹소켓 연결이 끊어짐 메세지 수신요청 종료
                    break
                }
                
                
                
                
//                listenToMessage()
            }
            
        })
    }
}



// MARK: URLSession
public extension BinanceWebSocketService {
    
    // Task완료시 호출된다.
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        
        guard let webSocketTask = task as? URLSessionWebSocketTask else { return }
        
        if let error {
            printIfDebug("\(Self.self): 웹소켓 작업에러발생 \(error.localizedDescription)")
            let taskId = webSocketTask.taskIdentifier
            if let completion = connectionCompletion[taskId] {
                // 웹소켓 최초연결 실패함, 성공했다면 클로저가 존재하지 않음
                completion(.failure(.connectionRequestFailure))
                connectionCompletion.remove(key: taskId)
            }
        }
    }
    
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        
        printIfDebug("BinanceWebSocketService: ✅ 웹소캣 연결됨")
        
        
        // 메서지 수신 시작
        listenToMessage()
        
        
        // Ping-pong 시작
        startHeartbeating()
        
        
        // 성공결과전송
        let taskId = webSocketTask.taskIdentifier
        if let completion = connectionCompletion[taskId] {
            completion(.success(()))
            connectionCompletion.remove(key: taskId)
        }
        
        
        // 웹소켓 상태 퍼블리싱
        webSocketStatePublisher.send(.connected)
    }
    
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        
        printIfDebug("BinanceWebSocketService: ☑️ 웹소캣 연결 끊김")
        
        
        // 웹소켓 상태 퍼블리싱
        switch closeCode {
        case .normalClosure:
            
            // 정상종료
            break
            
        default:
            
            // 비정상종료
            break
            
        }
    }
}


// MARK: Socket heart beat
extension BinanceWebSocketService {
    
    private func sendHeartbeatMessage() {
        
        currentWebSocketTask?.sendPing(pongReceiveHandler: { error in
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
