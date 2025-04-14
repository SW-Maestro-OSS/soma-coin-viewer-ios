//
//  CoinDetailPageViewModel.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/12/25.
//

import Combine
import SwiftUI

import DomainInterface
import BaseFeature
import CoreUtil

enum CoinDetailPageAction {
    case onAppear
    
    case updateOrderbook(bids: [Orderbook], asks: [Orderbook])
    case updateTickerInfo(info: TickerInfo)
}

final class CoinDetailPageViewModel: UDFObservableObject {
    // Dependency
    private let useCase: CoinDetailPageUseCase
    
    
    // State
    @Published var state: State
    private let symbolPair: String
    private var hasAppeared = false
    private let bidStore: OrderbookStore = .init()
    private let askStroe: OrderbookStore = .init()

    
    // Action
    typealias Action = CoinDetailPageAction
    let action: PassthroughSubject<CoinDetailPageAction, Never> = .init()
    
    
    // Streams
    private var orderbookStream: AnyCancellable?
    private var singleTickerStream: AnyCancellable?
    var store: Set<AnyCancellable> = .init()
    
    init(symbolPair: String, useCase: CoinDetailPageUseCase) {
        self.symbolPair = symbolPair
        self.useCase = useCase
        self.state = .init(symbolText: symbolPair.uppercased())
        
        createStateStream()
    }
    
    
    func mutate(_ action: CoinDetailPageAction) -> AnyPublisher<CoinDetailPageAction, Never> {
        switch action {
        case .onAppear:
            if !hasAppeared {
                hasAppeared = true
                startOrderbookStream()
                start24hTickerStream()
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
            guard let bigestQuantity = (bids + asks).map(\.quantity).max() else { break }
            newState.bidOrderbooks = bids.map {
                transform(bigestQuantity: bigestQuantity, orderbook: $0, type: .bid)
            }
            newState.askOrderbooks = asks.map {
                transform(bigestQuantity: bigestQuantity, orderbook: $0, type: .ask)
            }
        case .updateTickerInfo(let info):
            newState.tickerInfo = info
        default:
            break
        }
        return newState
    }
    
    private func transform(bigestQuantity: CVNumber, orderbook: Orderbook, type: OrderbookType) -> OrderbookCellRO {
        let percent = sqrt(pow(bigestQuantity.double, 2) - pow(bigestQuantity.double-orderbook.quantity.double, 2)) / bigestQuantity.double
        return OrderbookCellRO(
            type: type,
            priceText: orderbook.price.roundDecimalPlaces(exact: 4),
            quantityText: orderbook.quantity.roundDecimalPlaces(exact: 1),
            relativePercentOfQuantity: percent
        )
    }
}


// MARK: 24h ticker
private extension CoinDetailPageViewModel {
    func start24hTickerStream() {
        Task {
            useCase.connectToOrederbookStream(symbolPair: symbolPair)
            for await tickerVO in useCase.get24hTickerChange(symbolPair: symbolPair) {
                let (changePercentText, changePercentTextColor) = createChangePercentTextConfig(percent: tickerVO.changedPercent)
                action.send(.updateTickerInfo(info: .init(
                    changePercentText: changePercentText,
                    changePercentTextColor: changePercentTextColor,
                    currentPriceText: tickerVO.price.roundDecimalPlaces(exact: 4),
                    bestBidPriceText: tickerVO.bestBidPrice.roundDecimalPlaces(exact: 4),
                    bestAskPriceText: tickerVO.bestAskPrice.roundDecimalPlaces(exact: 4)
                )))
            }
        }
    }
    
    func createChangePercentTextConfig(percent: CVNumber) -> (String, Color) {
        let percentText = percent.roundToTwoDecimalPlaces()+"%"
        var displayText: String = percentText
        var displayColor: Color = .red
        if percent >= 0.0 {
            displayText = "+"+displayText
            displayColor = .green
        }
        return (displayText, displayColor)
    }
}


// MARK: Orderbook table
private extension CoinDetailPageViewModel {
    func startOrderbookStream() {
        let updateTracker = PassthroughSubject<Void, Never>()
        orderbookStream?.cancel()
        orderbookStream = updateTracker
            .throttle(for: 0.3, scheduler: DispatchQueue.global(), latest: true)
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
            useCase.connectToTickerChangesStream(symbolPair: symbolPair)
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
extension CoinDetailPageViewModel {
    struct State {
        // 24h ticker
        var symbolText: String
        var tickerInfo: TickerInfo?
        
        // Orderbook table
        var bidOrderbooks: [OrderbookCellRO] = []
        var askOrderbooks: [OrderbookCellRO] = []
    }
}

