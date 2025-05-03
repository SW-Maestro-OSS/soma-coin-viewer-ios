//
//  HTTPMethod.swift
//  Data
//
//  Created by choijunios on 2/4/25.
//

public enum HTTPMethod {
    case get, post, put, delete
    var httpRequestStr: String {
        switch self {
        case .get:
            "GET"
        case .post:
            "POST"
        case .put:
            "PUT"
        case .delete:
            "DELETE"
        }
    }
}
