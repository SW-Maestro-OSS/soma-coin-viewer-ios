//
//  NetworkServiceError.swift
//  Data
//
//  Created by choijunios on 2/4/25.
//

public enum NetworkServiceError: Error {
    case unexpectedError(message: String)
    case requestCreationFailed
    case invalidStatusCode(exception: HTTPResponseException)
    case underlying(error: Error)
}
