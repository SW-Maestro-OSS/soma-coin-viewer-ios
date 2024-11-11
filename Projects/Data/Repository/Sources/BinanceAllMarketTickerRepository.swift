//
//  BinanceAllMarketTickerRepository.swift
//  Repository
//
//  Created by choijunios on 11/1/24.
//

import Foundation
import Combine

import DataSource
import DomainInterface
import CoreUtil

public class BinanceAllMarketTickerRepository: AllMarketTickerRepository {
    
    @Injected var webSocketService: WebSocketService
    
    private var store: Set<AnyCancellable> = .init()
    
    private let decoder: JSONDecoder = .init()
    
    public init() { }
    
    public func request24hTickerForAllSymbols() -> AnyPublisher<[Twenty4HourTickerForSymbolVO], Never> {
                
        let publisher: PassthroughSubject<[Twenty4HourTickerForSymbolVO], Never> = .init()
        
        webSocketService
            .message
            .unretained(self)
            .sink { (repository, result) in
                
                switch result {
                    
                case .success(let message):
                    if case .string(let string) = message, let data = string.data(using: .utf8){
                        
                        let tickerDTOs = try! repository.decoder.decode([TickerForSymbolDTO].self, from: data)
                        
                        let entities = tickerDTOs.map { $0.toEntity() }
                        
                        publisher.send(entities)
                    }
                case .failure(let error):
                    
                    // 에러발생, 스트림 구독자가 해당 에러를 처리하지는 않는다.
                    
                    printIfDebug("All market tieker 스트림 구독자, 메세지에서 에러발견 \(error.localizedDescription)")
                }
                
            }
            .store(in: &store)
        
        return publisher.eraseToAnyPublisher()
    }
}
