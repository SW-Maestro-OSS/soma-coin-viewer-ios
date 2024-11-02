//
//  StreamConnectable.swift
//  Domain
//
//  Created by choijunios on 11/2/24.
//

import Foundation
import Combine

public protocol StreamConnectable {
    
    associatedtype Element
    associatedtype SomeError: Error
    
    func connect()
    
    func subscribe() -> AnyPublisher<Element, SomeError>
    func unsubscribe()
    
    func disconnect()
}
