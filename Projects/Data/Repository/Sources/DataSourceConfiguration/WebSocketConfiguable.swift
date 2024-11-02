//
//  WebSocketConfiguable.swift
//  Data
//
//  Created by choijunios on 11/2/24.
//

public enum WebSocketStream: Hashable {
    case allMarketTickers
}

public protocol WebSocketConfiguable {
    
    var baseURL: String { get }
    var streamName: [WebSocketStream: String] { get }
}
