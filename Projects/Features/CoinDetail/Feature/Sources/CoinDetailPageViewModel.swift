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
import PresentationUtil

enum CoinDetailPageAction {
    case onAppear
    
    case updateOrderbook(bids: [Orderbook], asks: [Orderbook])
    case updateTickerInfo(info: TickerInfo)
    case updateTrades(trades: [CoinTradeVO])
}

final class CoinDetailPageViewModel: UDFObservableObject {
    // Dependency
    private let useCase: CoinDetailPageUseCase
    
    
    // State
    @Published var state: State
    private let symbolPair: String
    private var hasAppeared = false
    private let bidStore: OrderbookStore = .init()
    private let askStore: OrderbookStore = .init()
    private let tradeContainer: TradeContainer = .init(maxCount: 15)
    
    
    // Action
    typealias Action = CoinDetailPageAction
    let action: PassthroughSubject<CoinDetailPageAction, Never> = .init()
    
    
    // Streams
    private var streamUpdateObserverStore: [CoinInfoStream: AnyCancellable] = [:]
    private var streamTask: [CoinInfoStream: Task<Void, Never>] = [:]
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
                startRecentTradeStream()
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
        case .updateTrades(let trades):
            newState.trades = trades.map(convertToRO)
        default:
            break
        }
        return newState
    }
    
    private func transform(bigestQuantity: CVNumber, orderbook: Orderbook, type: OrderbookType) -> OrderbookCellRO {
        return OrderbookCellRO(
            type: type,
            priceText: orderbook.price.roundDecimalPlaces(exact: 4),
            quantityText: orderbook.quantity.roundDecimalPlaces(exact: 1),
            relativePercentOfQuantity: orderbook.quantity.double / bigestQuantity.double
        )
    }
}


// MARK: 24h ticker
private extension CoinDetailPageViewModel {
    func start24hTickerStream() {
        streamTask[.changeInTicker]?.cancel()
        streamTask[.changeInTicker] = Task { [weak self] in
            guard let self else { return }
            useCase.connectToOrderbookStream(symbolPair: symbolPair)
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
        let updateTracker = PassthroughSubject<OrderbookUpdateVO, Never>()
        streamUpdateObserverStore[.orderbookTable]?.cancel()
        streamUpdateObserverStore[.orderbookTable] = updateTracker
            .throttle(for: 0.5, scheduler: DispatchQueue.global(), latest: true)
            .unretained(self)
            .asyncTransform { vm, update in
                // - 테이블 업데이트
                await vm.apply(bids: update.bids)
                await vm.apply(asks: update.asks)
                
                // - 리스트 추출
                let bidList = await vm.bidStore.getDescendingList(count: 15).map(Orderbook.init)
                let askList = await vm.askStore.getAscendingList(count: 15).map(Orderbook.init)
                return Action.updateOrderbook(bids: bidList, asks: askList)
            }
            .subscribe(self.action)
        
        streamTask[.orderbookTable]?.cancel()
        streamTask[.orderbookTable] = Task { [weak self] in
            guard let self else { return }
            useCase.connectToTickerChangesStream(symbolPair: symbolPair)
            do {
                // #1. 전체 테이블 요청
                let wholeTable = try await useCase.getWholeOrderbookTable(symbolPair: symbolPair)
                await clearOrderbookStore()
                updateTracker.send(wholeTable)
                
                // #2. 실시간 업데이트
                let sequence = useCase.getChangeInOrderbook(symbolPair: symbolPair).filter { entity in
                    entity.lastUpdateId > wholeTable.lastUpdateId
                }
                for await update in sequence {
                    updateTracker.send(update)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func clearOrderbookStore() async {
        await bidStore.clearStore()
        await askStore.clearStore()
    }
    
    func apply(bids: [Orderbook]) async {
        for bidOrder in bids {
            await bidStore.update(key: bidOrder.price, value: bidOrder.quantity)
        }
    }
    
    func apply(asks: [Orderbook]) async {
        for askOrder in asks {
            await askStore.update(key: askOrder.price, value: askOrder.quantity)
        }
    }
}


// MARK: Recent trade
private extension CoinDetailPageViewModel {
    func startRecentTradeStream() {
        let updateTracker = PassthroughSubject<Void, Never>()
        streamUpdateObserverStore[.recentTrade]?.cancel()
        streamUpdateObserverStore[.recentTrade] = updateTracker
            .throttle(for: 0.5, scheduler: DispatchQueue.global(), latest: true)
            .unretainedOnly(self)
            .asyncTransform { vm in
                let newList = await vm.tradeContainer.getList()
                return Action.updateTrades(trades: newList)
            }
            .subscribe(self.action)
        
        streamTask[.recentTrade]?.cancel()
        streamTask[.recentTrade] = Task { [weak self] in
            guard let self else { return }
            useCase.connectToRecentTradeStream(symbolPair: symbolPair)
            for await entity in useCase.getRecentTrade(symbolPair: symbolPair) {
                await tradeContainer.insert(element: entity)
                updateTracker.send(())
            }
        }
    }
    
    func convertToRO(_ entity: CoinTradeVO) -> CoinTradeRO {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.dateFormat = "HH:mm:ss"
        let renderObject: CoinTradeRO = .init(
            id: entity.tradeId,
            priceText: entity.price.roundDecimalPlaces(exact: 4),
            quantityText: entity.quantity.roundDecimalPlaces(exact: 4),
            timeText: dateFormatter.string(from: entity.tradeTime),
            textColor: entity.tradeType == .buy ? .green : .red,
            backgroundEffectColor: (entity.tradeType == .buy ? .green : .red)
        )
        return renderObject
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
        
        // Recent trade
        var trades: [CoinTradeRO] = []
        
        init(symbolText: String) {
            self.symbolText = symbolText
        }
    }
}

