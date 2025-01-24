//
//  FakeWebSocketService.swift
//  WebSocketManagementHelper
//
//  Created by choijunios on 1/24/25.
//

import Combine

import DataSource

class FakeWebSocketService: WebSocketService {
    
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
        fakeMessagePublisher.send(.success(.string("Subscribe success")))
    }
    
    func unsubscribeTo(message: [String], completion: @escaping WebsocketCompletion) {
        fakeMessagePublisher.send(.success(.string("Ubsubscribe success")))
    }
}
