//
//  SucessResponse.swift
//  Data
//
//  Created by choijunios on 2/4/25.
//

public struct SuccessResponse<DTO: Decodable> {
    public private(set) var body: DTO?
    public private(set) var headers: [AnyHashable: Any] = [:]
    
    mutating func set(body: DTO) {
        self.body = body
    }
    mutating func set(headers: [AnyHashable: Any]) {
        self.headers = headers
    }
}
