//
//  DefaultWebSockerHelper.swift
//  Data
//
//  Created by choijunios on 11/2/24.
//

import Foundation

import DataSource
import DomainInterface
import CoreUtil

public class DefaultWebSockerHelper: WebSocketHelper {
    
    @Injected var webSocketService: WebSocketService
    @Injected var webSocketConfig: WebSocketConfiguable
    
    public init() { }
    
    public func connect(completion: @escaping ((any Error)?) -> ()) {
        
        let baseURL: URL = .init(string: webSocketConfig.baseURL)!
        
        webSocketService
            .connect(to: baseURL) { error in
                
                // 도메인화 예정
                
                completion(error)
            }
    }

    public func disconnect() {
        
        webSocketService.disconnect()
    }
}
