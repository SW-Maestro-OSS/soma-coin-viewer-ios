//
//  DefaultWebSocketManagementHelper.swift
//
//

import Foundation

import DataSource
import CoreUtil

import Combine

public class DefaultWebSocketManagementHelper: WebSocketManagementHelper, WebSocketServiceListener {
    
    // Stream
    public typealias Stream = String
    
    
    // Service locator
    private let webSocketService: WebSocketService
    
    
    // Pulbic interface
    public private(set) var isWebSocketConnected: AnyPublisher<Bool, Never> = Empty().eraseToAnyPublisher()
    
    
    private var currentSubscribtions: Set<Stream> = []
    private let subscribedStreamManageQueue: DispatchQueue = .init(label: "com.WebSocketManagementHelper")
    private var store: Set<AnyCancellable> = .init()
    
    public init(webSocketService: WebSocketService) {
        self.webSocketService = webSocketService
        webSocketService.listener = self
    }
    
    
    public func requestSubscribeToStream(streams: [Stream]) {
        subscribedStreamManageQueue.async { [weak self] in
            guard let self else { return }
            // 스트림 구독 메세지 전송
            webSocketService.subscribeTo(message: streams) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    streams.forEach { stream in
                        printIfDebug("\(Self.self): ✅\(stream)구독 성공")
                    }
                    // 구독에 성공한 스트림들을 기록합니다.
                    add(streams: streams)
                case .failure(let webSocketError):
                    switch webSocketError {
                    case .messageTransferFailed(_):
                        streams.forEach { stream in
                            printIfDebug("\(Self.self): ❌\(stream)구독 실패")
                        }
                        
                        
                        // MARK: Error Shooter
                        
                        
                        return
                    default:
                        return
                    }
                }
            }
        }
    }
    
    
    public func requestUnsubscribeToStream(streams willRemoveStreams: [Stream]) {
        
        // 특정스트림에 대해 구독을 해제 메세지 전송
        webSocketService.unsubscribeTo(message: willRemoveStreams) { [weak self] result in
                       
            guard let self else { return }
            
            switch result {
            case .success:
                
                // 리커버리 리스트에서 해당 스트림을 제거
                subscribedStreamManageQueue.async { [weak self] in
                    
                    guard let self else { return }
                    
                    // 현재 구독중인 스트림에서 구독취소한 스트림 제거
                    currentSubscribtions = currentSubscribtions.filter { stream in
                        !willRemoveStreams.contains(stream)
                    }
                }
                
            case .failure(let webSocketError):
                
                switch webSocketError {
                case .messageTransferFailed(_):
                    printIfDebug("\(Self.self): 스트림 구독 해제 메세지 전송 실패")
                    
                    
                    // MARK: Error Shooter
                    
                    
                    break
                default:
                    break
                }
            }
        }
    }
    
    
    public func requestDisconnection() {
        webSocketService.disconnect()
    }
    
    
    public func requestConnection(connectionType: ConnectionType) {
        webSocketService.connect { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                if case .recoverPreviousStreams = connectionType {
                    // 구독됬던 스트림 복구 실행
                    recoverPreviouslySubscribedStreams()
                }
            case .failure(let error):
                // MARK: 웹소켓 연결 실패 대처
                printIfDebug("\(Self.self) 웹소켓 연결실패 \(error.localizedDescription)")
                return
            }
        }
    }
}

private extension DefaultWebSocketManagementHelper {
    
    /// 스트림을 기록합니다.
    func add(streams: [Stream]) {
        subscribedStreamManageQueue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            for stream in streams {
                currentSubscribtions.insert(stream)
            }
        }
    }
    
    
    /// 스트림을 제거합니다.
    func remove(streams: [Stream]) {
        subscribedStreamManageQueue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            for stream in streams {
                if let index = currentSubscribtions.firstIndex(of: stream) {
                    currentSubscribtions.remove(at: index)
                }
            }
        }
    }
    
    
    func recoverPreviouslySubscribedStreams() {
        subscribedStreamManageQueue.async { [weak self] in
            guard let self else { return }
            printIfDebug("\(Self.self) 스트림 복구 실행 \(currentSubscribtions)")
            let recoveringStreamList = Array(currentSubscribtions)
            self.requestSubscribeToStream(streams: recoveringStreamList)
        }
    }
}


// MARK: For Test
internal extension DefaultWebSocketManagementHelper {
    
    @available(*, deprecated, message: "테스트 목적이외에 방식으로 사용되면 안됩니다.")
    func getSavedStreams() -> [Stream] {
        subscribedStreamManageQueue.sync {
            return Array(currentSubscribtions)
        }
    }
}


// MARK: WebSocketServiceListener
public extension DefaultWebSocketManagementHelper {
    func webSocketListener(unrelatedError error: WebSocketError) {
        switch error {
        case .unintentionalDisconnection(let error):
            
            // MARK: Error Shooter
            
            break
        case .internetConnectionError(let error):
            
            // MARK: Error Shooter
            
            break
        case .serverIsBusy:
            
            // MARK: Error Shooter
            
            break
        case .tooManyRequests:
            
            // MARK: Error Shooter
            
            break
        case .unknown(let error):
            
            // MARK: Error Shooter
            
            break
        default:
            break
        }
    }
}
