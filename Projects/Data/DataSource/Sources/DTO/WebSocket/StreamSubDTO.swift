//
//  StreamSubDTO.swift
//  DataSource
//
//  Created by choijunios on 9/26/24.
//

import Foundation

struct StreamSubDTO: Codable {
    
    enum Method: String, Codable {
        case SUBSCRIBE
        case UNSUBSCRIBE
    }
    
    let method: Method
    let params: [String]
    let id: Int64
    
    init(
        method: Method,
        params: [String],
        id: Int64
    ) {
        self.method = method
        self.params = params
        self.id = id
    }
}
