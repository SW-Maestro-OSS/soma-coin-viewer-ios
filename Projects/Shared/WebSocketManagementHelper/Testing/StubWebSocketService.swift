//
//  StubWebSocketService.swift
//  WebSocketManagementHelper
//
//  Created by choijunios on 1/24/25.
//

import Combine

import DataSource

// MARK: 항상 성공결과를 반환하는 Stub
class StubAllwaysSuccessWebSocketService: WebSocketService {
    
    weak var listener: (any DataSource.WebSocketServiceListener)?
    
    private let fakeStatePublisher = PassthroughSubject<WebSocketState, Never>()
    
    func getMessageStream<DTO>() -> AnyPublisher<DTO, Never> where DTO : Decodable {
        return Just(1).compactMap {
            $0 as? DTO
        }
        .eraseToAnyPublisher()
    }
    
    func connect(completion: @escaping WebsocketCompletion) {
        fakeStatePublisher.send(.connected)
    }
    
    func disconnect() {
        fakeStatePublisher.send(.disconnected)
    }
    
    func subscribeTo(message: [String], mustDeliver: Bool, completion: @escaping WebsocketCompletion) {
        completion(.success(()))
    }
    
    func unsubscribeTo(message: [String], mustDeliver: Bool, completion: @escaping WebsocketCompletion) {
        completion(.success(()))
    }
}


// MARK: 항상 실패한 결과를 반환하는 Stub
class StubAllwaysFailureWebSocketService: WebSocketService {
    
    weak var listener: (any DataSource.WebSocketServiceListener)?
    
    private let fakeStatePublisher = PassthroughSubject<WebSocketState, Never>()
    
    func getMessageStream<DTO>() -> AnyPublisher<DTO, Never> where DTO : Decodable {
        return Just(1).compactMap {
            $0 as? DTO
        }
        .eraseToAnyPublisher()
    }
    
    func connect(completion: @escaping WebsocketCompletion) {
        fakeStatePublisher.send(.disconnected)
    }
    
    func disconnect() {
        fakeStatePublisher.send(.disconnected)
    }
    
    func subscribeTo(message: [String], mustDeliver: Bool, completion: @escaping WebsocketCompletion) {
        completion(.failure(WebSocketError.messageTransferFailed(error: nil)))
    }
    
    func unsubscribeTo(message: [String], mustDeliver: Bool, completion: @escaping WebsocketCompletion) {
        completion(.failure(WebSocketError.messageTransferFailed(error: nil)))
    }
}
