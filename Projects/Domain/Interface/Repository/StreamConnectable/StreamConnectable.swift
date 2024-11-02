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
    
    /// 웹소캣을 연결합니다.
    func connect(completion: (Error?) -> ())
    
    /// 구독을 실행합니다.
    func subscribe() -> AnyPublisher<Element, Error>
    
    /// 구독을 종료합니다.
    func unsubscribe()
    
    /// 웹소켓 연결을 종료합니다.
    func disconnect()
}
