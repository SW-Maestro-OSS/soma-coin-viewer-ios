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
    @Injected var webSocketConfig: WebSocketConfiguable
    
    private var tickerPublisher: PassthroughSubject<[Symbol24hTickerVO], Error>?
    
    private let jsonDecoder: JSONDecoder = .init()
    
    private var streamName: String {
        webSocketConfig.streamName[.allMarketTickers]!
    }
    
    public init() { }
    
    public func subscribe() -> AnyPublisher<[Symbol24hTickerVO], Error> {
        
        let publisher: PassthroughSubject<[Symbol24hTickerVO], Error> = .init()
        self.tickerPublisher = publisher
        
        webSocketService.subsribe(
            id: 1,
            to: streamName,
            subCallback: nil) { [jsonDecoder] message in
                
                if case .string(let string) = message, let data = string.data(using: .utf8){
                    
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
    
    public func unsubscribe() {
        
        // 퍼블리셔 메모리해제
        tickerPublisher = nil
        
        // 스트림 구독 취소
        webSocketService.unsubscribe(id: 1, from: [streamName]) { error in
            
            guard let error else { return }
            
            printIfDebug("스트림 해제 실패, \(error.localizedDescription)")
        }
    }
}
