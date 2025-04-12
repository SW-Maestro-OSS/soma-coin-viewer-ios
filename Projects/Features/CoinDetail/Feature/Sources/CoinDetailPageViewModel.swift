//
//  CoinDetailPageViewModel.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/12/25.
//

import Combine
import Foundation

import DomainInterface
import BaseFeature

public enum CoinDetailPageAction {
    case onAppear
    
    case updateOrderbook(bids: [Orderbook], asks: [Orderbook])
}

final public class CoinDetailPageViewModel: UDFObservableObject {
    // Dependency
    private let useCase: CoinDetailPageUseCase
    
    
    // State
    @Published public var state: State = .init()
    private let symbolPair: String
    private var hasAppeared = false
    private let bidStore: OrderbookStore = .init()
    private let askStroe: OrderbookStore = .init()

    
    // Action
    public let action: PassthroughSubject<CoinDetailPageAction, Never> = .init()
    
    public typealias Action = CoinDetailPageAction
    public var store: Set<AnyCancellable> = .init()
    private var orderbookStream: AnyCancellable?
    
    
    public init(symbolPair: String, useCase: CoinDetailPageUseCase) {
        self.symbolPair = symbolPair
        self.useCase = useCase
        
        createStateStream()
    }
    
    
    public func mutate(_ action: CoinDetailPageAction) -> AnyPublisher<CoinDetailPageAction, Never> {
        switch action {
        case .onAppear:
            if !hasAppeared {
                hasAppeared = true
                startOrderbookStream()
            }
            return Just(action).eraseToAnyPublisher()
        default:
            break
        }
        return Just(action).eraseToAnyPublisher()
    }
    
    public func reduce(_ action: CoinDetailPageAction, state: State) -> State {
        var newState = state
        switch action {
        case .updateOrderbook(let bids, let asks):
            newState.bidOrderbooks = bids.map(self.transform)
            newState.askOrderbooks = asks.map(self.transform)
        default:
            break
        }
        return newState
    }
    
    func transform(_ orderbook: Orderbook) -> OrderbookRO {
        OrderbookRO(
            id: orderbook.price.description,
            priceText: orderbook.price.roundToTwoDecimalPlaces(),
            quantityText: orderbook.quantity.roundToTwoDecimalPlaces()
        )
    }
}


// MARK: Orderbook
private extension CoinDetailPageViewModel {
    func startOrderbookStream() {
        let updateTracker = PassthroughSubject<Void, Never>()
        orderbookStream?.cancel()
        orderbookStream = updateTracker
            .throttle(for: 0.35, scheduler: DispatchQueue.global(), latest: true)
            .flatMap { [weak self] _ in
                return Future<Action, Never> { promise in
                    Task { [weak self] in
                        guard let self else { return }
                        let bidList = await bidStore.getDescendingList(count: 20).map(Orderbook.init)
                        let askList = await askStroe.getAscendingList(count: 20).map(Orderbook.init)
                        promise(.success(Action.updateOrderbook(bids: bidList, asks: askList)))
                    }
                }
                .eraseToAnyPublisher()
            }
            .subscribe(self.action)
        
        Task {
            useCase.connectToStream(symbolPair: symbolPair)
            do {
                // #1. 전체 테이블 요청
                let wholeTable = try await useCase.getWholeOrderbookTable(symbolPair: symbolPair)
                await clearOrderbookStore()
                await apply(bids: wholeTable.bids)
                await apply(asks: wholeTable.asks)
                updateTracker.send(())
                
                // #2. 실시간 업데이트
                let sequence = useCase.getChangeInOrderbook(symbolPair: symbolPair).filter { entity in
                    entity.lastUpdateId > wholeTable.lastUpdateId
                }
                for await update in sequence {
                    await apply(bids: update.bids)
                    await apply(asks: update.asks)
                    updateTracker.send(())
                }
            } catch {
                print(error)
            }
        }
    }
    
    func clearOrderbookStore() async {
        await bidStore.clearStore()
        await askStroe.clearStore()
    }
    
    func apply(bids: [Orderbook]) async {
        for bidOrder in bids {
            await bidStore.update(key: bidOrder.price, value: bidOrder.quantity)
        }
    }
    
    func apply(asks: [Orderbook]) async {
        for askOrder in asks {
            await askStroe.update(key: askOrder.price, value: askOrder.quantity)
        }
    }
}


// MARK: State
public extension CoinDetailPageViewModel {
    struct State {
        var bidOrderbooks: [OrderbookRO] = []
        var askOrderbooks: [OrderbookRO] = []
    }
}

