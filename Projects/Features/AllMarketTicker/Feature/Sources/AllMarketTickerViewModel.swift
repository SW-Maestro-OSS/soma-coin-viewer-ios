//
//  AllMarketTickerViewModel.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/5/24.
//

import SwiftUI
import Combine

import BaseFeature
import CoinDetailFeature
import DomainInterface
import I18N
import AlertShooter
import WebSocketManagementHelper
import CoreUtil

public protocol AllMarketTickerRouting: AnyObject { }

public enum AllMarketTickerPageListenerRequest {
    case presentCoinDetailPage(listener: CoinDetailPageListener, symbolInfo: CoinSymbolInfo)
    case dismissCoinDetailPage
}

public protocol AllMarketTickerPageListener: AnyObject {
    func request(_ request: AllMarketTickerPageListenerRequest)
}

enum AllMarketTickerAction {
    case view(ViewAction)
    case tickerListFetched(list: TickerList)
    case updateSortSelectionButtons(LanguageType, CurrencyType)
    case updateGridType(type: GridType)
    
    enum ViewAction {
        case onAppear
        case onDisappear
        case sortSelectionButtonTapped(index: Int)
        case tickerRowTapped(index: Int)
    }
}

@MainActor
final class AllMarketTickerViewModel: ObservableObject, AllMarketTickerViewModelable {
    // Dependency
    private let useCase: AllMarketTickersUseCase
    private let alertShooter: AlertShooter
    private let webSocketHelper: WebSocketManagementHelper
    private let i18NManager: I18NManager
    private let localizedStrProvider: LocalizedStrProvider
    
    weak var router: AllMarketTickerRouting?
    
    weak var listener: AllMarketTickerPageListener?
    
    @Published private(set) var state: State = State(
        sortSelectionCells: [],
        tickerRowCount: 0
    )
    private let tickerRowCount: Int = 30
    private var isFirstAppear: Bool = true
    
    typealias Action = AllMarketTickerAction
    private var store: Set<AnyCancellable> = []
    
    init(
        useCase: AllMarketTickersUseCase,
        alertShooter: AlertShooter,
        webSocketHelper: WebSocketManagementHelper,
        i18NManager: I18NManager,
        localizedStrProvider: LocalizedStrProvider
    ) {
        self.useCase = useCase
        self.alertShooter = alertShooter
        self.webSocketHelper = webSocketHelper
        self.i18NManager = i18NManager
        self.localizedStrProvider = localizedStrProvider
        
        let sortSelectionCells = createInitialSortSelectonROs()
        let initialState: State = .init(sortSelectionCells: sortSelectionCells, tickerRowCount: Int(tickerRowCount))
        self._state = Published(initialValue: initialState)
    }
    
    @MainActor
    private func handle(_ action: AllMarketTickerAction) {
        switch action {
        case .view(.onAppear):
            if self.isFirstAppear {
                self.isFirstAppear = false
                
                bindToAllMarketTickerStream()
                bindToScenePhase()
            }
            
            // activate all tickers stream
            webSocketHelper.requestSubscribeToStream(
                streams: [.allMarketTickerChangesIn24h],
                mustDeliver: true
            )
            
            checkUpdateInI18N()
            
        case .view(.onDisappear):
            // inactivate all tickers stream
            webSocketHelper.requestUnsubscribeToStream(
                streams: [.allMarketTickerChangesIn24h],
                mustDeliver: false
            )
            
        case .view(.tickerRowTapped(let index)):
            if let selectedTicker = state.tickerList?.tickers[index] {
                let pairSymbol = selectedTicker.pairSymbol
                listener?.request(.presentCoinDetailPage(
                    listener: self,
                    symbolInfo: .init(
                        firstSymbol: pairSymbol.firstSymbol,
                        secondSymbol: pairSymbol.secondSymbol
                    )
                ))
            }
            break
            
        case .view(.sortSelectionButtonTapped(let index)):
            var newState = state
            let selectedModel = state.sortSelectionModels[index]
            
            // set sort ui state
            newState.sortSelectionModels = state.sortSelectionModels.map { model in
                var newModel = model
                if model.sortType == selectedModel.sortType {
                    newModel.sortDirection = model.sortDirection.nextDirectionOnTap()
                    return newModel
                } else {
                    newModel.sortDirection = .neutral
                    return newModel
                }
            }
            
            // sort ticker list
            let nextDirection = selectedModel.sortDirection.nextDirectionOnTap()
            let comparator = selectedModel.sortType.getComparator(direction: nextDirection)
            newState.currentComparator = comparator
            
            if let oldList = newState.tickerList {
                let currencyType = oldList.currencyType
                newState.tickerCellModels = oldList.tickers
                    .sorted(by: comparator.compare)
                    .map { createTickerCellRO($0, currencyType: currencyType) }
            }
            self.state = newState
            
        case .tickerListFetched(let list):
            var newState = state
            let currencyType = list.currencyType
            
            var tickers = list.tickers
            if list.tickers.count > tickerRowCount {
                let slicedTickers = list.tickers.sorted {
                    $0.totalTradedQuoteAssetVolume > $1.totalTradedQuoteAssetVolume
                }
                tickers = Array(slicedTickers.prefix(tickerRowCount))
            }
            
            newState.tickerList = TickerList(currencyType: currencyType, tickers: tickers)
            newState.tickerCellModels = tickers
                .sorted(by: state.currentComparator.compare)
                .map { ticker in
                    createTickerCellRO(ticker, currencyType: currencyType)
                }
            self.state = newState
            
        case .updateSortSelectionButtons(let languageType, let currencyType):
            var newState = state
            
            if let prevCurrencyType = newState.tickerList?.currencyType {
                if prevCurrencyType != currencyType {
                    newState.tickerCellModels = []
                }
            }
            
            newState.sortSelectionModels = state.sortSelectionModels.map { renderObject in
                let newText = createSortSelectionButtonText(
                    sortType: renderObject.sortType,
                    languageType: languageType,
                    currenyType: currencyType
                )
                var newObject = renderObject
                newObject.displayText = newText
                return newObject
            }
            
            self.state = newState
            
        case .updateGridType(let gridType):
            var newState = state
            newState.tickerGridType = gridType
            self.state = newState
        }
    }
    
    private func checkUpdateInI18N() {
        let languageType = i18NManager.getLanguageType()
        let currencyType = i18NManager.getCurrencyType()
        let gridType = useCase.getGridType()
        
        send(.updateSortSelectionButtons(languageType, currencyType))
        send(.updateGridType(type: gridType))
    }
}


// MARK: Public interface
extension AllMarketTickerViewModel {
    func send(_ action: Action) { handle(action) }
}


// MARK: State & Action
extension AllMarketTickerViewModel {
    struct State {
        var sortSelectionModels: [SortSelectionCellRO]
        var sortSelectionCount: Int { sortSelectionModels.count }
        fileprivate var currentComparator: TickerComparator = TickerNoneComparator()
        
        let tickerRowCount: Int
        var tickerGridType: GridType = .list
        var tickerCellModels: [TickerCellRO] = []
        var tickerCellCount: Int { tickerCellModels.count }
        fileprivate var tickerList: TickerList?
        
        var isLoaded: Bool { !tickerCellModels.isEmpty }
        
        init(sortSelectionCells: [SortSelectionCellRO], tickerRowCount: Int) {
            self.sortSelectionModels = sortSelectionCells
            self.tickerRowCount = tickerRowCount
        }
    }
}


// MARK: Bindings
private extension AllMarketTickerViewModel {
    func bindToAllMarketTickerStream() {
        useCase
            .getTickerListStream()
            .throttle(for: 0.5, scheduler: DispatchQueue.main, latest: true)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] list in
                guard let self else { return }
                send(.tickerListFetched(list: list))
            })
            .store(in: &store)
    }
    
    func bindToScenePhase() {
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                webSocketHelper.requestSubscribeToStream(
                    streams: [.allMarketTickerChangesIn24h],
                    mustDeliver: true
                )
            }
            .store(in: &store)
        
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                webSocketHelper.requestUnsubscribeToStream(
                    streams: [.allMarketTickerChangesIn24h],
                    mustDeliver: false
                )
            }
            .store(in: &store)
    }
}


// MARK: Create ticker cell render object
private extension AllMarketTickerViewModel {
    func createTickerCellRO(_ ticker: Ticker, currencyType: CurrencyType) -> TickerCellRO {
        let symbolText = ticker.pairSymbol.fullSymbol.uppercased()
        let symbolImageURL = createSymbolImageURL(symbol: ticker.pairSymbol.firstSymbol)
        let priceText = createPriceText(ticker.price, currencyType: currencyType)
        let (cpText, cpTextColor) = createChangePercentTextConfig(ticker.changedPercent)
        return TickerCellRO(
            symbolText: symbolText,
            symbolImageURL: symbolImageURL,
            priceText: priceText,
            changePercentText: cpText,
            changePercentTextColor: cpTextColor
        )
    }
    
    func createSymbolImageURL(symbol: String) -> String {
        let baseURL = URL(string: "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/refs/heads/master/32/icon")!
        let symbolImageURL = baseURL.appendingPathComponent(symbol.lowercased(), conformingTo: .png)
        return symbolImageURL.absoluteString
    }
    
    func createChangePercentTextConfig(_ percent: Decimal) -> (String, Color) {
        let percentText = roundDecimal(percent, fractionLimit: 2)+"%"
        var displayText: String = percentText
        var displayColor: Color = .red
        if percent >= 0.0 {
            displayText = "+"+displayText
            displayColor = .green
        }
        return (displayText, displayColor)
    }
    
    func createPriceText(_ price: Decimal, currencyType: CurrencyType) -> String {
        let currency_symbol = currencyType.symbol
        let formatted_price_text = roundDecimal(price, fractionLimit: 2)
        
        var price_text: String
        if currencyType.isPrefix {
            price_text = "\(currency_symbol) \(formatted_price_text)"
        } else {
            price_text = "\(formatted_price_text) \(currency_symbol)"
        }
        return price_text
    }
}


// MARK: Decimal formatting
private extension AllMarketTickerViewModel {
    func roundDecimal(_ number: Decimal, fractionLimit: Int) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = fractionLimit
        formatter.minimumFractionDigits = fractionLimit
        formatter.roundingMode = .down
        let formattedString = formatter.string(from: number as NSDecimalNumber)
        return formattedString ?? "-1.0"
    }
}


// MARK: Create sort selection cell render objects
private extension AllMarketTickerViewModel {
    func createInitialSortSelectonROs() -> [SortSelectionCellRO] {
        SortSelectionCellType.orderedList.map { sortType in
            SortSelectionCellRO(sortType: sortType, sortDirection: .neutral)
        }
    }
}


// MARK: I18N
private extension AllMarketTickerViewModel {
    func createSortSelectionButtonText(sortType type: SortSelectionCellType, languageType: LanguageType, currenyType: CurrencyType) -> String {
        switch type {
        case .symbol:
            return localizedStrProvider.getString(
                key: .pageKey(page: .allMarketTicker(contents: .tableSymbolColumnTitle)),
                languageType: languageType
            )
        case .price:
            return localizedStrProvider.getString(
                key: .pageKey(page: .allMarketTicker(contents: .tablePriceColumnTitle)),
                languageType: languageType
            )+"(\(currenyType.symbol))"
        case .changeIn24h:
            return localizedStrProvider.getString(
                key: .pageKey(page: .allMarketTicker(contents: .table24hchangeColumnTitle)),
                languageType: languageType
            )
        }
    }
}


// MARK: CoinDetailPageListener
extension AllMarketTickerViewModel: CoinDetailPageListener {
    func request(_ request: CoinDetailPageListenerRequest) {
        switch request {
        case .closePage:
            listener?.request(.dismissCoinDetailPage)
        }
    }
}
