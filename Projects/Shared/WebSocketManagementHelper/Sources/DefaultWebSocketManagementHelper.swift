//
//  DefaultWebSocketManagementHelper.swift
//
//

import Foundation

import WebSocketManagementHelperInterface
import DataSource
import CoreUtil

import Combine

public class DefaultWebSocketManagementHelper: WebSocketManagementHelper {
    
    public typealias Stream = String
    
    @Injected private var webSocketService: WebSocketService
    
    
    // Pulbic interface
    public private(set) var isWebSocketConnected: AnyPublisher<Bool, Never> = Empty().eraseToAnyPublisher()
    
    
    private var subscribtions: Set<Stream> = []
    private let subscribedStreamManageQueue: DispatchQueue = .init(label: "com.WebSocketManagementHelper")
    private var store: Set<AnyCancellable> = .init()
    
    public init() {
        
        
        // 외부에 상태전파
        self.isWebSocketConnected = webSocketService
            .state
            .map { state in
                state == .connected
            }
            .eraseToAnyPublisher()
        
        
        // 웹소켓 상태 수신 및 회복처리
        webSocketService
            .state
            .sink { [weak self] state in
                
                guard let self else { return }
                
                switch state {
                case .initial:
                    
                    return
                    
                case .connected:
                    
                    printIfDebug("WebSocketManagementHelper: ✅ 웹소켓 연결됨")
                    
                case .intentionalDisconnection:
                    
                    // 의도된 연결 해제
                    printIfDebug("WebSocketManagementHelper: ☑️ 웹소켓 연결 해제됨")
                    
                    
                case .unexpectedDisconnection:
                    
                    // 의도되지 않은 끊어짐
                    
                    printIfDebug("WebSocketManagementHelper: ❌ 웹소켓 연결 끊어짐, 🔁 복구실행")
                    
                    // 연결재시도 및 스트림 복구 실행
                    requestConnection(connectionType: .recoverPreviousStreams)
                }
                
            }
            .store(in: &store)
    }
    
    
    public func requestSubscribeToStream(streams: [Stream]) {
        
        subscribedStreamManageQueue.async { [weak self] in
            
            guard let self else { return }
            
            let newStreams = streams.filter { stream in
                
                !self.subscribtions.contains(stream)
            }
            
            // 스트림 구독 메세지 전송
            webSocketService.subscribeTo(message: newStreams) { [weak self] result in
                
                guard let self else { return }
                
                switch result {
                case .success:
                    
                    // 리커버리 리스트에 구독된 리스트들을 추가합니다.
                    addSubscriptionsToRecoveryList(streams: newStreams)
                    
                case .failure(let webSocketError):
                    
                    switch webSocketError {
                    case .messageTransferFailure(let message):
                        
                        // MARK: 매세지 전송 실패 대처
                        printIfDebug("WebSocketManagementHelper: 스트림 구독 메세지 전송 실패")
                        
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
                    
                    self.subscribtions = subscribtions.filter { stream in
                        
                        !willRemoveStreams.contains(stream)
                    }
                }
                
            case .failure(let webSocketError):
                
                switch webSocketError {
                case .messageTransferFailure(let message):
                    
                    // MARK: 매세지 전송 실패 대처
                    printIfDebug("WebSocketManagementHelper: 스트림 구독 해제 메세지 전송 실패")
                    
                    return
                default:
                    return
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
                
                return
            }
        }
    }
}

private extension DefaultWebSocketManagementHelper {
    
    func addSubscriptionsToRecoveryList(streams: [Stream]) {
        
        subscribedStreamManageQueue.async(flags: .barrier) { [weak self] in
            
            streams.forEach { stream in
                
                self?.subscribtions.insert(stream)
            }
        }
    }
    
    func recoverPreviouslySubscribedStreams() {
        
        subscribedStreamManageQueue.async { [weak self] in
            
            guard let self else { return }
            
            let recoveringStreamList = Array(subscribtions)
            
            self.requestSubscribeToStream(streams: recoveringStreamList)
        }
    }
}
