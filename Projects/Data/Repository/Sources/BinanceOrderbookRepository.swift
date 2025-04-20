//
//  BinanceOrderbookRepository.swift
//  Data
//
//  Created by choijunios on 4/12/25.
//

import Foundation
import Combine

import DomainInterface
import DataSource
import CoreUtil

final public class BinanceOrderbookRepository: OrderbookRepository {
    // Dependency
    @Injected var webSocketService: WebSocketService
    private let httpService: HTTPService = .init()
    
    // Store
    private let bidOrderbookStore = ThreadSafeOrderbookHashMap()
    private let askOrderbookStore = ThreadSafeOrderbookHashMap()
    
    public init() { }
    
    public func getWholeTable(symbolPair: String) async throws -> OrderbookUpdateVO {
        let requestBuiler = URLRequestBuilder(
            base: .init(string: "https://api.binance.com/api/v3")!,
            httpMethod: .get
        )
        .add(path: "depth")
        .add(queryParam: [
            "symbol": symbolPair.uppercased(),
            "limit": "5000"
        ])
        let dto = try await httpService.request(requestBuiler, dtoType: BinanceOrderbookTableDTO.self, retry: 1)
        return dto.body!.toEntity()
    }
    
    public func getUpdate(symbolPair: String) -> AsyncStream<DomainInterface.OrderbookUpdateVO> {
        let publisher = webSocketService
            .getMessageStream()
            .filter({ (dto: BinacneOrderbookUpdateDTO) in
                dto.symbol.lowercased() == symbolPair.lowercased()
            })
            .map({ $0.toEntity() })
        return AsyncStream { continuation in
            let cancellable = publisher
                .sink(receiveValue: { entity in
                    continuation.yield(entity)
                })
            continuation.onTermination = { @Sendable [cancellable] _ in
                cancellable.cancel()
            }
        }
    }
    
    public func getOrderbookTable(symbolPair: String) -> AnyPublisher<OrderbookTableVO, Never> {
        webSocketService
            .getMessageStream()
            .filter { (dto: BinacneOrderbookUpdateDTO) in
                dto.symbol.lowercased() == symbolPair.lowercased()
            }
            .unretained(self)
            .asyncTransform { repo, dto in
                // #1. 레포지토리에 데이터 저장
                let adaptToRepository = { (orderbooks: [[String]], store: ThreadSafeOrderbookHashMap) in
                    for askOrderbook in dto.asks {
                        let price = CVNumber(Decimal(string: askOrderbook[0])!)
                        let qty = CVNumber(Decimal(string: askOrderbook[1])!)
                        if qty.wrappedNumber == 0 {
                            await store.removeValue(price)
                        } else {
                            await store.insert(key: price, value: qty)
                        }
                    }
                }
                await adaptToRepository(dto.bids, repo.bidOrderbookStore)
                await adaptToRepository(dto.asks, repo.askOrderbookStore)
                
                // #2. 데이터를 엔티티로 변경
                return OrderbookTableVO(
                    askOrderbooks: await repo.askOrderbookStore.hashMap.copy(),
                    bidOrderbooks: await repo.bidOrderbookStore.hashMap.copy()
                )
            }
    }
}

actor ThreadSafeOrderbookHashMap {
    let hashMap: HashMap<CVNumber, CVNumber> = .init()
    
    subscript (_ key: CVNumber) -> CVNumber? {
        get { hashMap[key] }
    }
    
    func insert(key: CVNumber, value: CVNumber) {
        hashMap[key] = value
    }
    
    func removeValue(_ forKey: CVNumber) {
        hashMap.removeValue(forKey)
    }
}
