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
    
    /// 구독을 실행합니다.
    func subscribe() -> AnyPublisher<Element, Error>
    
    /// 구독을 종료합니다.
    func unsubscribe()
}
