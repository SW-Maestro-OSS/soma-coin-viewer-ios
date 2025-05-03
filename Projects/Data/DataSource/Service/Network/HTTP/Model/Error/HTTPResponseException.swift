//
//  HTTPResponseException.swift
//  Data
//
//  Created by choijunios on 2/4/25.
//

public struct HTTPResponseException: Error {
    public let status: HttpResponseStatus
    
    public init(status: HttpResponseStatus) {
        self.status = status
    }
}
