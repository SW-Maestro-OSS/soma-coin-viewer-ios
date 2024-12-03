//
//  DefaultWebSocketManagementHelper.swift
//
//

import Foundation

import StreamControllerInterface
import DataSource
import CoreUtil

public class DefaultWebSocketManagementHelper: WebSocketManagementHelper {
    
    @Injected var webSocketService: WebSocketService
    
    private var subscribtions: Set<String> = []
    
    private let subscribedStreamManageQueue: DispatchQueue = .init(label: "com.WebSocketManagementHelper")
    
    public func requestSubscribeToStream(streams: [String]) {
        
        subscribedStreamManageQueue.async { [weak self] in
            
            guard let self else { return }
            
            var notConnectedStreams: Set<String> = []
            
            for stream in streams {
                
                if !subscribtions.contains(where: { $0 == stream }) {
                    
                    // 기존에 연결되지 않은 스트림인 경우
                    
                    subscribtions.insert(stream)
                    
                    notConnectedStreams.insert(stream)
                }
            }
            
            webSocketService.subscribeTo(messageParameters: Array(notConnectedStreams))
        }
    }
    
    public func requestUnsubscribeToStream(streams willRemoveStreams: [String]) {
        
        // 특정스트림에 대해 구독을 해제
        webSocketService.unsubscribeTo(messageParameters: willRemoveStreams)
        
        
        // 리커버리 리스트에서 해당 스트림을 제거
        subscribedStreamManageQueue.async { [weak self] in
            
            guard let self else { return }
            
            self.subscribtions = subscribtions.filter { stream in
                
                !willRemoveStreams.contains(stream)
            }
        }
    }
    
    public func requestDisconnection() {
        
        webSocketService.disconnect()
    }
    
    public func requestConnection(connectionType: StreamControllerInterface.ConnectionType) {
        
        webSocketService.connect()
    }
}
