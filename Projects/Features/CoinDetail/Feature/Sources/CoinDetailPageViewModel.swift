//
//  CoinDetailPageViewModel.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/12/25.
//

import SwiftUI
import Combine

import DomainInterface
import BaseFeature
import CoreUtil
import I18N
import WebSocketManagementHelper

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
    case getBackToForeground
    
    case updateOrderbook(bids: [Orderbook], asks: [Orderbook])
    case updateTickerInfo(entity: Twenty4HourTickerForSymbolVO)
    case updateTrades(trades: [CoinTradeVO])
}

final class CoinDetailPageViewModel: UDFObservableObject, CoinDetailPageViewModelable {
    // Dependency
    private let useCase: CoinDetailPageUseCase
    private let i18NManager: I18NManager
    private let webSocketManagementHelper: WebSocketManagementHelper
    
    
    // Listener
    weak var listener: CoinDetailPageListener?
    
    
    // State
    @Published var state: State
    private let symbolInfo: CoinSymbolInfo
    private var symbolPair: String { symbolInfo.pairSymbol }
    private var hasAppeared = false
    private let orderbookRowCount: Int = 15
    private let recentTradeRowCount: Int = 20

    // Action
    typealias Action = CoinDetailPageAction
    let action: PassthroughSubject<CoinDetailPageAction, Never> = .init()
    
    
    // Streams
    private var streamUpdateObserverStore: [CoinInfoStream: AnyCancellable] = [:]
    private var streamTask: [CoinInfoStream: Task<Void, Never>] = [:]
    var store: Set<AnyCancellable> = .init()
    
    init(
        symbolInfo: CoinSymbolInfo,
        useCase: CoinDetailPageUseCase,
        i18NManager: I18NManager,
        webSocketManagementHelper: WebSocketManagementHelper
    ) {
        self.symbolInfo = symbolInfo
        self.useCase = useCase
        self.i18NManager = i18NManager
        self.webSocketManagementHelper = webSocketManagementHelper
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
                webSocketManagementHelper.requestSubscribeToStream(streams: [
                    .tickerChangesIn24h(symbolPair: symbolPair),
                    .orderbook(symbolPair: symbolPair),
                    .recentTrade(symbolPair: symbolPair)
                ], mustDeliver: true)
            }
            return Just(action).eraseToAnyPublisher()
        case .onDisappear:
            // 연결 스트림 종료
            webSocketManagementHelper.requestUnsubscribeToStream(streams: [
                .tickerChangesIn24h(symbolPair: symbolPair),
                .orderbook(symbolPair: symbolPair),
                .recentTrade(symbolPair: symbolPair)
            ], mustDeliver: true)
            
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
            webSocketManagementHelper.requestSubscribeToStream(streams: [
                .tickerChangesIn24h(symbolPair: symbolPair),
                .orderbook(symbolPair: symbolPair),
                .recentTrade(symbolPair: symbolPair)
            ], mustDeliver: true)
        default:
            break
        }
        return Just(action).eraseToAnyPublisher()
    }
    
    func reduce(_ action: CoinDetailPageAction, state: State) -> State {
        var newState = state
        switch action {
        case .updateOrderbook(let bids, let asks):
            guard let biggestQuantity = (bids + asks).map(\.quantity).max() else { break }
            newState.bidOrderbooks = bids.map {
                transform(biggestQuantity: biggestQuantity, orderbook: $0, type: .bid)
            }
            newState.askOrderbooks = asks.map {
                transform(biggestQuantity: biggestQuantity, orderbook: $0, type: .ask)
            }
            
        case .updateTickerInfo(let entity):
            let (changePercentText, changeType) = createChangePercentTextConfig(percent: entity.changedPercent)
            newState.priceChagePercentInfo = .init(
                changeType: changeType,
                percentText: changePercentText
            )
            let currenyConfig = CurrencyConfig(
                type: i18NManager.getCurrencyType(),
                ratePerStandard: 1
            )
            newState.tickerInfo = createTickerInfoRO(
                languageType: i18NManager.getLanguageType(),
                currencyConfig: currenyConfig,
                entity: entity
            )
            
        case .updateTrades(let trades):
            newState.trades = trades.map(convertToRO)
        default:
            break
        }
        return newState
    }
    
    enum LocalizedStrings {
        case tickerCurrentPrice
        case tickerBestBidPrice
        case tickerBestAskPrice
        
        var key: String {
            switch self {
            case .tickerCurrentPrice:
                "CoinDetailPage_ticker_currentPrice"
            case .tickerBestBidPrice:
                "CoinDetailPage_ticker_bestBidPrice"
            case .tickerBestAskPrice:
                "CoinDetailPage_ticker_bestAskPrice"
            }
        }
    }
    
    struct CurrencyConfig {
        let type: CurrencyType
        let ratePerStandard: Double
    }
}


// MARK: 24h ticker
private extension CoinDetailPageViewModel {
    func createTickerInfoRO(
        languageType lanT: LanguageType,
        currencyConfig cc: CurrencyConfig,
        entity: Twenty4HourTickerForSymbolVO) -> TickerInfoRO {
            
        let currentPriceText = CVNumber(entity.price.double * cc.ratePerStandard).description
        let bestBidPriceText = CVNumber(entity.bestBidPrice.double * cc.ratePerStandard).description
        let bestAskPriceText = CVNumber(entity.bestAskPrice.double * cc.ratePerStandard).description
        
        let strProvider = LocalizedStringProvider.instance()
        return .init(
            currentPriceTitleText: strProvider.getString(
                key: LocalizedStrings.tickerCurrentPrice.key,
                lanCode: lanT.lanCode
            ),
            bestBidPriceTitleText: strProvider.getString(
                key: LocalizedStrings.tickerBestBidPrice.key,
                lanCode: lanT.lanCode
            ),
            bestAskPriceTitleText: strProvider.getString(
                key: LocalizedStrings.tickerBestAskPrice.key,
                lanCode: lanT.lanCode
            ),
            currentPriceText: currentPriceText,
            bestBidPriceText: bestBidPriceText,
            bestAskPriceText: bestAskPriceText
        )
    }
    
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
        streamUpdateObserverStore[.orderbookTable]?.cancel()
        streamUpdateObserverStore[.orderbookTable] = useCase
            .getOrderbookTable(symbolPair: symbolPair, rowCount: UInt(orderbookRowCount))
            .throttle(for: 0.5, scheduler: DispatchQueue.global(), latest: true)
            .catch({ error in
                printIfDebug("[\(Self.self)]: \(error.localizedDescription)")
                return Just(OrderbookTableVO(bidOrderbooks: [], askOrderbooks: []))
            })
            .map { table in
                Action.updateOrderbook(
                    bids: table.bidOrderbooks,
                    asks: table.askOrderbooks
                )
            }
            .subscribe(self.action)
    }
    
    func transform(biggestQuantity: CVNumber, orderbook: Orderbook, type: OrderbookType) -> OrderbookCellRO {
        return OrderbookCellRO(
            type: type,
            priceText: orderbook.price.description,
            quantityText: orderbook.quantity.formatCompactNumberWithSuffix(),
            relativePercentOfQuantity: orderbook.quantity.double / biggestQuantity.double
        )
    }
}


// MARK: Recent trade
private extension CoinDetailPageViewModel {
    func listenToRecentTradeStream() {
        streamUpdateObserverStore[.recentTrade]?.cancel()
        streamUpdateObserverStore[.recentTrade] = useCase
            .getRecentTrade(symbolPair: symbolPair, maxRowCount: UInt(recentTradeRowCount))
            .throttle(for: 1.0, scheduler: DispatchQueue.global(), latest: true)
            .map { Action.updateTrades(trades: $0) }
            .subscribe(self.action)
    }
    
    func convertToRO(_ entity: CoinTradeVO) -> CoinTradeRO {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.dateFormat = "HH:mm:ss"
        let renderObject: CoinTradeRO = .init(
            id: entity.tradeId,
            priceText: entity.price.description,
            quantityText: entity.quantity.formatCompactNumberWithSuffix(),
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
        // Title
        let symbolText: String
        
        // 24h ticker
        var priceChagePercentInfo: PriceChangePercentRO?
        var tickerInfo: TickerInfoRO?
        
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
