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
    
    // WebSocket service url
    private static let baseURL: URL = .init(string: "wss://stream.binance.com:443/ws")!
    
    
    // Listener
    public weak var listener: WebSocketServiceListener?
    

    // Message
    private let messageEncoder = JSONEncoder()
    private let messageDecoder: JSONDecoder = .init()
    private let unsentMessages: MessageStore = .init()
    
    
    // Internal publishers
    private typealias Message = URLSessionWebSocketTask.Message
    private let webSocketMessagePublisher: PassthroughSubject<Message, Never> = .init()
    private var store: Set<AnyCancellable> = []
    
    
    // Network
    private let webSocketManagementQueue: DispatchQueue = .init(label: "com.webSocket.management")
    private var webSocketSession: URLSession!
    private var currentWebSocketTask: URLSessionWebSocketTask?
    private var timerForHeartbeat: DispatchSourceTimer?
    private let heartbeatTimerQueue: DispatchQueue = .init(label: "com.heartbeat")
    
    
    // Connection callback
    private let connectionCompletion: LockedDictionary<Int, WebsocketCompletion> = .init()
    
    
    public override init() {
        super.init()
        setupWebSocketSession()
        subscribeToWebSocketMessageStreamForMessageError()
    }
}


// MARK: Send message
private extension BinanceWebSocketService {
    typealias MessageDTO = BinanceWebSocketStreamMessageDTO
    
    class MessageStore {
        struct Bundle {
            let message: MessageDTO
            let completion: WebsocketCompletion
        }
        private var bundles: [Bundle] = []
        private let lock = NSLock()
        
        func append(bundle: Bundle) {
            defer { lock.unlock() }
            lock.lock()
            bundles.append(bundle)
        }
        
        func getAndClear() -> [Bundle] {
            defer { lock.unlock() }
            lock.lock()
            let copy = bundles
            bundles.removeAll()
            return copy
        }
    }
    
    func sendMessage(_ message: BinanceWebSocketStreamMessageDTO, completion: @escaping (Result<Void, WebSocketError>) -> Void) {
        let jsonData = try! messageEncoder.encode(message)
        let stringedMessage = String(data: jsonData, encoding: .utf8)!
        currentWebSocketTask?.send(.string(stringedMessage)) { [weak self] error in
            guard let self else { return }
            if let error {
                let webSocketError = handleNSError(error as NSError)
                completion(.failure(webSocketError))
            } else {
                completion(.success(()))
            }
        }
    }
}


// MARK: Setup session
private extension BinanceWebSocketService {
    func setupWebSocketSession() {
        let sessionQueue = OperationQueue()
        self.webSocketSession = URLSession(configuration: .default, delegate: self, delegateQueue: sessionQueue)
    }
}


// MARK: Stream subscription or unsubscription
public extension BinanceWebSocketService {
    func subscribeTo(message: [String], mustDeliver: Bool, completion: @escaping WebsocketCompletion) {
        webSocketManagementQueue.async { [weak self] in
            guard let self, !message.isEmpty else { return }
            let messageDTO = BinanceWebSocketStreamMessageDTO(
                method: .SUBSCRIBE,
                params: message,
                id: 1
            )
            
            // 구독 메세지 전송
            if currentWebSocketTask?.state != .running {
                // 웹소켓이 연결되어있지 않은 경우
                if mustDeliver {
                    // 반드시 전달해야하는 매세지인 경우
                    unsentMessages.append(bundle: .init(message: messageDTO, completion: completion))
                }
            } else {
                sendMessage(messageDTO) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        let webSocketError = handleNSError(error as NSError)
                        completion(.failure(.messageTransferFailed(error: webSocketError)))
                    }
                }
            }
        }
    }
    
    
    func unsubscribeTo(message: [String], mustDeliver: Bool, completion: @escaping WebsocketCompletion) {
        webSocketManagementQueue.async { [weak self] in
            guard let self, !message.isEmpty else { return }
            let messageDTO = BinanceWebSocketStreamMessageDTO(
                method: .UNSUBSCRIBE,
                params: message,
                id: 1
            )
            
            // 구독취소 메세지 전송
            if currentWebSocketTask?.state != .running {
                // 웹소켓이 연결되어있지 않은 경우
                if mustDeliver {
                    // 반드시 전달해야하는 매세지인 경우
                    unsentMessages.append(bundle: .init(message: messageDTO, completion: completion))
                }
            } else {
                sendMessage(messageDTO) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        let webSocketError = handleNSError(error as NSError)
                        completion(.failure(.messageTransferFailed(error: webSocketError)))
                    }
                }
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
            if currentWebSocketTask?.state == .running { return }
            
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
                guard currentWebSocketTask?.state == .running else { return }
                let webSocketError = handleNSError(error as NSError)
                listener?.webSocketListener(unrelatedError: webSocketError)
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
                let webSocketError = handleNSError(error as NSError)
                completion(.failure(.unintentionalDisconnection(error: webSocketError)))
                connectionCompletion.remove(key: taskId)
            }
        }
    }
    
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        printIfDebug("\(Self.self): ✅ 웹소캣 연결됨")
        
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
        
        // 전송되지 못한 메세지 전송
        unsentMessages.getAndClear().forEach { bundle in
            sendMessage(bundle.message, completion: bundle.completion)
        }
    }
    
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        printIfDebug("\(Self.self): ☑️ 웹소캣 연결 끊김")
        if closeCode != .normalClosure {
            // 웹소켓이 정상적으로 종료되지 못한 경우
            listener?.webSocketListener(unrelatedError: .unintentionalDisconnection(
                error: nil
            ))
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
        
        // 이전 작업 취소
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


// MARK: Error handling
private extension BinanceWebSocketService {
    
    // Binance에러처리
    func subscribeToWebSocketMessageStreamForMessageError() {
        webSocketMessagePublisher
            .compactMap({ message in
                switch message {
                case .string(let str):
                    return str.data(using: .utf8)
                case .data(let data):
                    return data
                @unknown default:
                    return nil
                }
            })
            .sink { [weak self] data in
                guard let self else { return }
                guard let binaceError = handleMessageError(data: data) else { return }
                switch binaceError {
                case .tooManyRequests:
                    listener?.webSocketListener(
                        unrelatedError: .tooManyRequests
                    )
                case .serverBusy:
                    listener?.webSocketListener(
                        unrelatedError: .serverIsBusy
                    )
                default:
                    return
                }
            }
            .store(in: &store)
    }
    
    private func handleMessageError(data: Data) -> BinanceWebSocketError? {
        let response = try? messageDecoder.decode(BinanceResponseDTO.self, from: data)
        guard let response, let errorDTO = response.error else { return nil }
        let binanceError = BinanceWebSocketError(rawValue: errorDTO.code) ?? .unknown
        return binanceError
    }
    
    func handleNSError(_ nsError: NSError) -> WebSocketError {
        switch nsError.domain {
        case NSPOSIXErrorDomain:
            // NSPOSIXErrorDomain: 네트워크 소켓 및 저수준 POSIX 관련 에러
            switch nsError.code {
            case 57:
                // 웹소켓 연결이 끊어짐
                return .unintentionalDisconnection(error: nsError)
            default:
                break
            }
        case NSURLErrorDomain:
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet:
                // 네트워크가 인터넷에 연결되지 못함
                return .internetConnectionError(error: nsError)
            default:
                break
            }
        default:
            break
        }
        return .unknown(error: nsError)
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
