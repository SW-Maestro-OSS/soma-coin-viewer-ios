//
//  WebSocket.swift
//  CoinViewer
//
//  Created by choijunios on 11/2/24.
//

import Repository

public class WebSocketConfiguration: WebSocketConfiguable {
    
    public let baseURL: String = "wss://stream.binance.com:443/ws"
    
    public let streamName: [WebSocketStream : String] = [
        .allMarketTickers : "!ticker@arr"
    ]
}
