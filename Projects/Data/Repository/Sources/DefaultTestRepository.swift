//
//  DefaultTestRepository.swift
//  Repository
//
//  Created by choijunios on 9/26/24.
//

import Foundation
import Domain

public class DefaultTestRepository: TestRepository {
    
    public init() { }
    
    public func getSayHelloText() -> String {
        "Hello world"
    }
}
