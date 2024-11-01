//
//  DefaultAllMarketTickerRepository.swift
//  Repository
//
//  Created by choijunios on 11/1/24.
//

import Foundation
import Combine

import DataSource
import DomainInterface
import CoreUtil

public class DefaultAllMarketTickerRepository: AllMarketTickerRepository {
    
    @Injected var webSocketService: WebSocketService
    
    private var tickerPublisher: PassthroughSubject<[Symbol24hTickerVO], Never>?
    
    private let jsonDecoder: JSONDecoder = .init()
    
    private let streamName: String = "!ticker@arr"
    
    public init() { }
    
    public func subscribeToStream() -> AnyPublisher<[DomainInterface.Symbol24hTickerVO], Never> {
        
        let publisher: PassthroughSubject<[Symbol24hTickerVO], Never> = .init()
        self.tickerPublisher = publisher
        
        webSocketService.subsribe(
            id: 1,
            to: streamName,
            onError: nil) { [jsonDecoder] message in
                
                if case .data(let data) = message {
                    
                    do {
                        let dtos = try jsonDecoder.decode([SymbolTickerDTO].self, from: data)
                        
                        let entities = dtos.map { $0.toEntity() }
                        
                        publisher.send(entities)
                        
                    } catch {
                        // 다른 스트림 or 디코딩 실패
                    }
                }
            }
        
        return publisher.eraseToAnyPublisher()
    }
    
    public func unsubscribeFromStream() {
        
        webSocketService.unsubscribe(id: 1, from: [streamName]) { error in
            
            printIfDebug("스트림 해제 실패, \(error.localizedDescription)")
        }
    }
}
