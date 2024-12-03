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
    private let subscribedStreamManageQueue: DispatchQueue = .init(
        label: "com.WebSocketManagementHelper",
        attributes: .concurrent
    )
    
    public func requestSubscribeToStream(streams: [String]) {
        
        subscribedStreamManageQueue.async(flags: .barrier) { [weak self] in
            
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
    
    public func requestUnsubscribeToStream(streams: [String]) {
        
        webSocketService.unsubscribeTo(messageParameters: streams)
        
        subscribedStreamManageQueue.async(flags: .barrier) { [weak self] in
            
            guard let self else { return }
            
            for stream in streams {
                
                if let index = subscribtions.firstIndex(where: { $0 == stream }) {
                    
                    subscribtions.remove(at: index)
                }
            }
        }
    }
    
    public func requestDisconnection() {
        
    }
    
    public func requestConnection(connectionType: StreamControllerInterface.ConnectionType) {
        
    }
}
