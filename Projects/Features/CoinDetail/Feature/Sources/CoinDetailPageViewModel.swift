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

enum CoinDetailPageAction {
    case onAppear
    
    case updateOrderbook(bids: [Orderbook], asks: [Orderbook])
}

final class CoinDetailPageViewModel: UDFObservableObject {
    // Dependency
    private let useCase: CoinDetailPageUseCase
    
    
    // State
    @Published var state: State = .init()
    private let symbolPair: String
    private var hasAppeared = false
    private let bidStore: OrderbookStore = .init()
    private let askStroe: OrderbookStore = .init()

    
    // Action
    let action: PassthroughSubject<CoinDetailPageAction, Never> = .init()
    
    typealias Action = CoinDetailPageAction
    var store: Set<AnyCancellable> = .init()
    private var orderbookStream: AnyCancellable?
    
    
    init(symbolPair: String, useCase: CoinDetailPageUseCase) {
        self.symbolPair = symbolPair
        self.useCase = useCase
    }
    
    
    func mutate(_ action: CoinDetailPageAction) -> AnyPublisher<CoinDetailPageAction, Never> {
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
    
    func reduce(_ action: CoinDetailPageAction, state: State) -> State {
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
            priceText: orderbook.price.roundToTwoDecimalPlaces(),
            quantityText: orderbook.quantity.roundToTwoDecimalPlaces()
        )
    }
}


// MARK: Orderbook
extension CoinDetailPageViewModel {
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
                let wholeTable = try await useCase.getWholeOrderbookTable(symbolPair: symbolPair)
                let sequence = useCase.getChangeInOrderbook(symbolPair: symbolPair).filter { entity in
                    entity.lastUpdateId > wholeTable.lastUpdateId
                }
                for await update in sequence {
                    for bidOrder in update.bids {
                        await bidStore.update(key: bidOrder.price, value: bidOrder.quantity)
                    }
                    for askOrder in update.asks {
                        await askStroe.update(key: askOrder.price, value: askOrder.quantity)
                    }
                    updateTracker.send(())
                }
            } catch {
                print(error)
            }
        }
    }
}


// MARK: State
extension CoinDetailPageViewModel {
    struct State {
        var bidOrderbooks: [OrderbookRO] = []
        var askOrderbooks: [OrderbookRO] = []
    }
}

