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
    
    case tickerInfoFetched(entity: Twenty4HourTickerForSymbolVO)
    case orderbookFetched(table: OrderbookTableVO)
    case coinTradesFetched(trades: [CoinTradeVO])
    case updateOrderbook(bids: [Orderbook], asks: [Orderbook], exchangeRateInfo: ExchangeRateInfo)
    case updateTickerInfo(entity: Twenty4HourTickerForSymbolVO, exchangeRateInfo: ExchangeRateInfo)
    case updateCoinTrades(trades: [CoinTradeVO], exchangeRateInfo: ExchangeRateInfo)
    case updateStaticUI(languageType: LanguageType, currencyType: CurrencyType)
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
            return Just(action)
                .unretainedOnly(self)
                .asyncTransform { vm in
                    let lanType = vm.i18NManager.getLanguageType()
                    let curType = vm.i18NManager.getCurrencyType()
                    return Action.updateStaticUI(
                        languageType: lanType,
                        currencyType: curType
                    )
                }
            
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
            
        case .tickerInfoFetched(let entity):
            return Just(entity)
                .unretained(self)
                .asyncTransform { vm, entity in
                    let currencyType = vm.i18NManager.getCurrencyType()
                    let rate = await vm.useCase.getExchangeRate(to: currencyType)
                    return Action.updateTickerInfo(
                        entity: entity,
                        exchangeRateInfo: .init(
                            currentType: currencyType,
                            rate: rate ?? 1.0
                        )
                    )
                }
            
        case .orderbookFetched(let table):
            return Just(table)
                .unretained(self)
                .asyncTransform { vm, entity in
                    let currencyType = vm.i18NManager.getCurrencyType()
                    let rate = await vm.useCase.getExchangeRate(to: currencyType)
                    return Action.updateOrderbook(
                        bids: table.bidOrderbooks,
                        asks: table.askOrderbooks,
                        exchangeRateInfo: .init(
                            currentType: currencyType,
                            rate: rate ?? 1.0
                        )
                    )
                }
            
        case .coinTradesFetched(let trades):
            return Just(trades)
                .unretained(self)
                .asyncTransform { vm, entity in
                    let currencyType = vm.i18NManager.getCurrencyType()
                    let rate = await vm.useCase.getExchangeRate(to: currencyType)
                    return Action.updateCoinTrades(
                        trades: trades,
                        exchangeRateInfo: .init(
                            currentType: currencyType,
                            rate: rate ?? 1.0
                        )
                    )
                }
        default:
            break
        }
        return Just(action).eraseToAnyPublisher()
    }
    
    func reduce(_ action: CoinDetailPageAction, state: State) -> State {
        var newState = state
        switch action {
        case .updateStaticUI(let languageType, let currencyType):
            let priceTitleText = LocalizedStringProvider.instance().getString(
                key: LocalizedStrings.columnPriceTitle.key,
                lanCode: languageType.lanCode
            ) + "(\(currencyType.symbol))"
            let qtyTitleText = LocalizedStringProvider.instance().getString(
                key: LocalizedStrings.columnQtyTitle.key,
                lanCode: languageType.lanCode
            )
            newState.orderbookTableColumnTitleRO = .init(
                qtyText: qtyTitleText,
                priceText: priceTitleText
            )
            
        case .updateOrderbook(let bids, let asks, let exchangeRateInfo):
            guard let biggestQuantity = (bids + asks).map(\.quantity).max() else { break }
            newState.bidOrderbooks = bids.map {
                createOrderbookCellRO(
                    biggestQuantity: biggestQuantity,
                    orderbook: $0,
                    type: .bid,
                    exchangeRateInfo: exchangeRateInfo
                )
            }
            newState.askOrderbooks = asks.map {
                createOrderbookCellRO(
                    biggestQuantity: biggestQuantity,
                    orderbook: $0,
                    type: .ask,
                    exchangeRateInfo: exchangeRateInfo
                )
            }
            
        case .updateTickerInfo(let entity, let exchangeRateInfo):
            let (changePercentText, changeType) = createChangePercentTextConfig(percent: entity.changedPercent)
            newState.priceChagePercentInfo = .init(
                changeType: changeType,
                percentText: changePercentText
            )
            newState.tickerInfo = createTickerInfoRO(
                languageType: i18NManager.getLanguageType(),
                exchangeRateInfo: exchangeRateInfo,
                entity: entity
            )
            
        case .updateCoinTrades(let trades, let exchangeRateInfo):
            newState.trades = trades.map { entity in
                createCoinTradeRO(entity: entity, exchangeRateInfo: exchangeRateInfo)
            }
        default:
            break
        }
        return newState
    }
    
    enum LocalizedStrings {
        case tickerCurrentPrice
        case tickerBestBidPrice
        case tickerBestAskPrice
        
        case columnQtyTitle
        case columnPriceTitle
        case columnTimeTitle
        
        var key: String {
            switch self {
            case .tickerCurrentPrice:
                "CoinDetailPage_ticker_currentPrice"
            case .tickerBestBidPrice:
                "CoinDetailPage_ticker_bestBidPrice"
            case .tickerBestAskPrice:
                "CoinDetailPage_ticker_bestAskPrice"
            case .columnQtyTitle:
                "CoinDetailPage_columnTitle_qty"
            case .columnTimeTitle:
                "CoinDetailPage_columnTitle_time"
            case .columnPriceTitle:
                "CoinDetailPage_columnTitle_price"
            }
        }
    }
    
    
    private func createPriceText(info: ExchangeRateInfo, price: CVNumber, symbolPresentable: Bool = true) -> String {
        let priceText = CVNumber(price.double * info.rate)
            .adaptiveFractionFormat(min: 2, max: 8)
        if symbolPresentable {
            if info.currentType.isPrefix {
                return "\(info.currentType.symbol) \(priceText)"
            } else {
                return "\(priceText) \(info.currentType.symbol)"
            }
        } else {
            return priceText
        }
    }
}


// MARK: 24h ticker
private extension CoinDetailPageViewModel {
    func createTickerInfoRO(
        languageType lanT: LanguageType,
        exchangeRateInfo: ExchangeRateInfo,
        entity: Twenty4HourTickerForSymbolVO) -> TickerInfoRO {
            
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
            currentPriceText: createPriceText(
                info: exchangeRateInfo,
                price: entity.price
            ),
            bestBidPriceText: createPriceText(
                info: exchangeRateInfo,
                price: entity.bestBidPrice
            ),
            bestAskPriceText: createPriceText(
                info: exchangeRateInfo,
                price: entity.bestAskPrice
            )
        )
    }
    
    func listenToChangeInTickerStream() {
        streamTask[.changeInTicker]?.cancel()
        streamTask[.changeInTicker] = Task { [weak self] in
            guard let self else { return }
            for await tickerVO in useCase.get24hTickerChange(symbolPair: symbolPair) {
                action.send(.tickerInfoFetched(entity: tickerVO))
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
                Action.orderbookFetched(table: table)
            }
            .subscribe(self.action)
    }
    
    func createOrderbookCellRO(
        biggestQuantity: CVNumber,
        orderbook: Orderbook,
        type: OrderbookType,
        exchangeRateInfo: ExchangeRateInfo
    ) -> OrderbookCellRO {
        
        OrderbookCellRO(
            type: type,
            priceText: createPriceText(
                info: exchangeRateInfo,
                price: orderbook.price,
                symbolPresentable: false
            ),
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
            .map { Action.coinTradesFetched(trades: $0) }
            .subscribe(self.action)
    }
    
    func createCoinTradeRO(entity: CoinTradeVO, exchangeRateInfo: ExchangeRateInfo) -> CoinTradeRO {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "HH:mm:ss"
        let renderObject: CoinTradeRO = .init(
            id: entity.tradeId,
            priceText: createPriceText(
                info: exchangeRateInfo,
                price: entity.price,
                symbolPresentable: false
            ),
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
        var orderbookTableColumnTitleRO: OrderbookTableColumnTitleRO?
        var bidOrderbooks: [OrderbookCellRO] = []
        var askOrderbooks: [OrderbookCellRO] = []
        
        // Recent trade
        var trades: [CoinTradeRO] = []
        
        // View Loading
        var isLoaded: Bool {
            tickerInfo != nil &&
            orderbookTableColumnTitleRO != nil &&
            !bidOrderbooks.isEmpty &&
            !askOrderbooks.isEmpty
        }
        
        init(symbolText: String, fixedOrderbookRowCount: Int) {
            self.symbolText = symbolText
            self.fixedOrderbookRowCount = fixedOrderbookRowCount
        }
    }
}
