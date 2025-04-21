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

public final class BinanceOrderbookRepository: OrderbookRepository {
    // Dependency
    @Injected var webSocketService: WebSocketService
    private let httpService: HTTPService = .init()
    
    // Store
    private let bidOrderbookStore = ThreadSafeOrderbookHashMap()
    private let askOrderbookStore = ThreadSafeOrderbookHashMap()
    
    public init() { }
}


// MARK: OrderbookRepository
public extension BinanceOrderbookRepository {
    func getWholeTable(symbolPair: String) async throws -> OrderbookUpdateVO {
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
    
    func getUpdate(symbolPair: String) -> AsyncStream<DomainInterface.OrderbookUpdateVO> {
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
    
    func getOrderbookTable(symbolPair: String) -> AnyPublisher<OrderbookTable, Error> {
        let httpRequest = getWholeOrderbookTable(symbolPair: symbolPair).share()
        let httpTableUpdate = httpRequest
            .unretained(self)
            .asyncTransform { repo, dto -> Void in
                // 최초저장전 저장소 초기화
                await repo.clearStore()
                await repo.adaptToStore(orderbooks: dto.bids, storeType: .bid)
                await repo.adaptToStore(orderbooks: dto.asks, storeType: .ask)
            }
        let webSocketTableUpdate = httpRequest
            .map(\.lastUpdateId)
            .unretained(self)
            .flatMap { repo, lastUpdateId in
                repo.webSocketService
                    .getMessageStream()
                    .filter { (dto: BinacneOrderbookUpdateDTO) in dto.symbol.lowercased() == symbolPair.lowercased() }
                    .filter { dto in dto.finalUpdateId > lastUpdateId }
                    .unretained(self)
                    .asyncTransform { repo, dto -> Void in
                        await repo.adaptToStore(orderbooks: dto.bids, storeType: .bid)
                        await repo.adaptToStore(orderbooks: dto.asks, storeType: .ask)
                    }
            }
        return Publishers
            .Merge(
                httpTableUpdate,
                webSocketTableUpdate
            )
            .unretainedOnly(self)
            .asyncTransform { repo in
                OrderbookTable(
                    bidOrderbooks: await repo.bidOrderbookStore.hashMap.copy(),
                    askOrderbooks: await repo.askOrderbookStore.hashMap.copy()
                )
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}



// MARK: Update orderbook store
private extension BinanceOrderbookRepository {
    func clearStore() async {
        await bidOrderbookStore.removeAll()
        await askOrderbookStore.removeAll()
    }
    
    enum StoreType { case bid, ask }
    func adaptToStore(orderbooks: [[String]], storeType: StoreType) async {
        var store: ThreadSafeOrderbookHashMap
        switch storeType {
        case .bid:
            store = bidOrderbookStore
        case .ask:
            store = askOrderbookStore
        }
        for orderbook in orderbooks {
            let price = CVNumber(Decimal(string: orderbook[0])!)
            let qty = CVNumber(Decimal(string: orderbook[1])!)
            if qty.wrappedNumber <= 0 {
                await store.removeValue(price)
            } else {
                await store.insert(key: price, value: qty)
            }
        }
    }
    
    func getWholeOrderbookTable(symbolPair: String) -> AnyPublisher<BinanceOrderbookTableDTO, NetworkServiceError> {
        let requestBuiler = URLRequestBuilder(
            base: .init(string: "https://api.binance.com/api/v3")!,
            httpMethod: .get
        )
        .add(path: "depth")
        .add(queryParam: [
            "symbol": symbolPair.uppercased(),
            "limit": "5000"
        ])
        return httpService
            .request(requestBuiler, dtoType: BinanceOrderbookTableDTO.self)
            .compactMap(\.body)
            .eraseToAnyPublisher()
    }
}

