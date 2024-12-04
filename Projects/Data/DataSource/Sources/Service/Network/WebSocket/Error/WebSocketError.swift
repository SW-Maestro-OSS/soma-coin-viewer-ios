//
//  WebSocketError.swift
//  Data
//
//  Created by choijunios on 12/4/24.
//

import Foundation

public enum WebSocketError: Error {

    case connectionRequestFailure
    case messageTransferFailure(message: Any?)
    case undelying(error: Error)
}
