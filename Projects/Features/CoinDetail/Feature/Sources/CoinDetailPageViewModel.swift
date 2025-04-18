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

public enum CoinDetailPageListenerRequest {
    case closePage
}

public protocol CoinDetailPageListener: AnyObject {
    func request(_ request: CoinDetailPageListenerRequest)
}

public protocol CoinDetailPageRouting: AnyObject { }

enum CoinDetailPageAction {
    case onAppear
    case onDisappear
    case exitButtonTapped
    case enterBackground
    case getBackToForeground
    
    case updateOrderbook(bids: [Orderbook], asks: [Orderbook])
    case updateTickerInfo(entity: Twenty4HourTickerForSymbolVO)
    case updateTrades(trades: [CoinTradeVO])
}

final class CoinDetailPageViewModel: UDFObservableObject, CoinDetailPageViewModelable {
    // Dependency
    private let useCase: CoinDetailPageUseCase
    
    
    // Listener
    weak var listener: CoinDetailPageListener?
    
    
    // State
    @Published var state: State
    private let symbolInfo: CoinSymbolInfo
    private var symbolPair: String { symbolInfo.pairSymbol }
    private var hasAppeared = false
    private let orderbookRowCount: Int = 15
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
    
    init(symbolInfo: CoinSymbolInfo, useCase: CoinDetailPageUseCase) {
        self.symbolInfo = symbolInfo
        self.useCase = useCase
        self.state = .init(
            symbolText: symbolInfo.pairSymbol.uppercased(),
            fixedOrderbookRowCount: orderbookRowCount
        )
        
        createStateStream()
    }
    
    func mutate(_ action: CoinDetailPageAction) -> AnyPublisher<CoinDetailPageAction, Never> {
        switch action {
        case .onAppear:
            if !hasAppeared {
                hasAppeared = true
                
                // 스크림 구독
                listenToChangeInTickerStream()
                listenToOrderbookStream()
                listenToRecentTradeStream()
                
                // 스트림 연결
                useCase.connectToTickerChangesStream(symbolPair: symbolPair)
                useCase.connectToOrderbookStream(symbolPair: symbolPair)
                useCase.connectToRecentTradeStream(symbolPair: symbolPair)
            }
            return Just(action).eraseToAnyPublisher()
        case .onDisappear:
            // 연결 스트림 종료
            useCase.disconnectToStreams(symbolPair: symbolPair)
            
            // AsyncStream종료
            streamTask.values.forEach({ $0.cancel() })
            streamTask.removeAll()
        case .exitButtonTapped:
            // 페이지 닫기
            listener?.request(.closePage)
        case .getBackToForeground:
            // 오더북 스트림만 상태 초기화 및 재구독
            listenToOrderbookStream()
            
            // 스트림 연결
            useCase.connectToTickerChangesStream(symbolPair: symbolPair)
            useCase.connectToOrderbookStream(symbolPair: symbolPair)
            useCase.connectToRecentTradeStream(symbolPair: symbolPair)
        case .enterBackground:
            useCase.disconnectToStreams(symbolPair: symbolPair)
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
        case .updateTickerInfo(let entity):
            let (changePercentText, changeType) = createChangePercentTextConfig(percent: entity.changedPercent)
            newState.priceChagePercentInfo = .init(
                changeType: changeType,
                percentText: changePercentText
            )
            newState.tickerInfo =
                .init(
                    currentPriceText: entity.price.roundDecimalPlaces(exact: 4),
                    bestBidPriceText: entity.bestBidPrice.roundDecimalPlaces(exact: 4),
                    bestAskPriceText: entity.bestAskPrice.roundDecimalPlaces(exact: 4)
                )
        case .updateTrades(let trades):
            newState.trades = trades.map(convertToRO)
        default:
            break
        }
        return newState
    }
}


// MARK: 24h ticker
private extension CoinDetailPageViewModel {
    func listenToChangeInTickerStream() {
        streamTask[.changeInTicker]?.cancel()
        streamTask[.changeInTicker] = Task { [weak self] in
            guard let self else { return }
            for await tickerVO in useCase.get24hTickerChange(symbolPair: symbolPair) {
                action.send(.updateTickerInfo(entity: tickerVO))
            }
        }
    }
    
    func createChangePercentTextConfig(percent: CVNumber) -> (String, ChangeType) {
        let percentText = percent.roundToTwoDecimalPlaces()+"%"
        var displayText: String = percentText
        if percent > 0.0 {
            displayText = "+"+displayText
        }
        var changeType: ChangeType = .neutral
        let percentNumber = percent.wrappedNumber
        if percentNumber < 0 {
            changeType = .minus
        } else if percentNumber > 0 {
            changeType = .plus
        }
        return (displayText, changeType)
    }
}


// MARK: Orderbook table
private extension CoinDetailPageViewModel {
    func listenToOrderbookStream() {
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
                let bidList = await vm.bidStore.getDescendingList(count: vm.orderbookRowCount).map(Orderbook.init)
                let askList = await vm.askStore.getAscendingList(count: vm.orderbookRowCount).map(Orderbook.init)
                return Action.updateOrderbook(bids: bidList, asks: askList)
            }
            .subscribe(self.action)
        
        streamTask[.orderbookTable]?.cancel()
        streamTask[.orderbookTable] = Task { [updateTracker, weak self] in
            guard let self else { return }
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
    
    func transform(bigestQuantity: CVNumber, orderbook: Orderbook, type: OrderbookType) -> OrderbookCellRO {
        return OrderbookCellRO(
            type: type,
            priceText: orderbook.price.roundDecimalPlaces(exact: 4),
            quantityText: orderbook.quantity.roundDecimalPlaces(exact: 4),
            relativePercentOfQuantity: orderbook.quantity.double / bigestQuantity.double
        )
    }
}


// MARK: Recent trade
private extension CoinDetailPageViewModel {
    func listenToRecentTradeStream() {
        let updateTracker = PassthroughSubject<CoinTradeVO, Never>()
        streamUpdateObserverStore[.recentTrade]?.cancel()
        streamUpdateObserverStore[.recentTrade] = updateTracker
            .throttle(for: 1.0, scheduler: DispatchQueue.global(), latest: true)
            .unretained(self)
            .asyncTransform { vm, update in
                // - 주문정보 업데이트
                await vm.tradeContainer.insert(element: update)
                
                // - 새로운 리스트 추출
                let newList = await vm.tradeContainer.getList()
                return Action.updateTrades(trades: newList)
            }
            .subscribe(self.action)
        
        streamTask[.recentTrade]?.cancel()
        streamTask[.recentTrade] = Task { [updateTracker, weak self] in
            guard let self else { return }
            for await entity in useCase.getRecentTrade(symbolPair: symbolPair) { updateTracker.send(entity) }
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
        let symbolText: String
        var priceChagePercentInfo: PriceChangePercentRO?
        var tickerInfo: TickerInfo?
        
        // Orderbook table
        let fixedOrderbookRowCount: Int
        var bidOrderbooks: [OrderbookCellRO] = []
        var askOrderbooks: [OrderbookCellRO] = []
        
        // Recent trade
        var trades: [CoinTradeRO] = []
        
        // View Loading
        var isLoaded: Bool {
            tickerInfo != nil &&
            !bidOrderbooks.isEmpty &&
            !askOrderbooks.isEmpty
        }
        
        init(symbolText: String, fixedOrderbookRowCount: Int) {
            self.symbolText = symbolText
            self.fixedOrderbookRowCount = fixedOrderbookRowCount
        }
    }
}

