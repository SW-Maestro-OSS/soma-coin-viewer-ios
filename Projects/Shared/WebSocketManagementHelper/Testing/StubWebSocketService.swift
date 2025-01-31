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
    
    private let fakeMessagePublisher = PassthroughSubject<Response, Never>()
    private let fakeStatePublisher = PassthroughSubject<WebSocketState, Never>()
    lazy var message: AnyPublisher<Response, Never> = fakeMessagePublisher.eraseToAnyPublisher()
    lazy var state: AnyPublisher<DataSource.WebSocketState, Never> = fakeStatePublisher.eraseToAnyPublisher()
    
    func connect(completion: @escaping WebsocketCompletion) {
        fakeStatePublisher.send(.connected)
    }
    
    func disconnect() {
        fakeStatePublisher.send(.intentionalDisconnection)
    }
    
    func subscribeTo(message: [String], completion: @escaping WebsocketCompletion) {
        completion(.success(()))
    }
    
    func unsubscribeTo(message: [String], completion: @escaping WebsocketCompletion) {
        completion(.success(()))
    }
}


// MARK: 항상 실패한 결과를 반환하는 Stub
class StubAllwaysFailureWebSocketService: WebSocketService {
    
    private let fakeMessagePublisher = PassthroughSubject<Response, Never>()
    private let fakeStatePublisher = PassthroughSubject<WebSocketState, Never>()
    lazy var message: AnyPublisher<Response, Never> = fakeMessagePublisher.eraseToAnyPublisher()
    lazy var state: AnyPublisher<DataSource.WebSocketState, Never> = fakeStatePublisher.eraseToAnyPublisher()
    
    func connect(completion: @escaping WebsocketCompletion) {
        fakeStatePublisher.send(.unexpectedDisconnection)
    }
    
    func disconnect() {
        fakeStatePublisher.send(.unexpectedDisconnection)
    }
    
    func subscribeTo(message: [String], completion: @escaping WebsocketCompletion) {
        completion(.failure(WebSocketError.messageTransferFailure(message: "")))
    }
    
    func unsubscribeTo(message: [String], completion: @escaping WebsocketCompletion) {
        completion(.failure(WebSocketError.messageTransferFailure(message: "")))
    }
}
