//
//  TickerCellViewModel.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI
import Combine

import BaseFeature

import DomainInterface
import CoreUtil

import SimpleImageProvider

final class TickerCellViewModel: Identifiable, UDFObservableObject {
    
    // Id
    public let id: String
    
    
    // Configuration
    let tickerVO: Twenty4HourTickerForSymbolVO
    let currencyConfig: CurrencyConfig
    
    
    // State
    @Published public var state: State = .init(
        firstSymbolImageURL: "",
        pairSymbolNameText: "",
        priceText: "",
        percentText: ""
    )
    private(set) var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    init(config: Configuration) {
        
        self.id = config.tickerVO.pairSymbol
        self.tickerVO = config.tickerVO
        self.currencyConfig = config.currencyConfig
        
        let initialState: State = .init(
            firstSymbolImageURL: createImageURL(),
            pairSymbolNameText: tickerVO.pairSymbol,
            priceText: createPriceText(),
            percentText: createPercentText()
        )
        
        self._state = Published(initialValue: initialState)
        
        createStateStream()
    }
    
    
    func reduce(_ action: Action, state: State) -> State {
        
        var newState = state
        
        switch action {
        case .updatePriceText(let text):
            newState.priceText = text
        }
        
        return newState
    }
}


// MARK: Configuration
extension TickerCellViewModel {
    
    struct Configuration {
        let tickerVO: Twenty4HourTickerForSymbolVO
        let currencyConfig: CurrencyConfig
    }
    
    struct CurrencyConfig {
        let type: CurrencyType
        let rate: Double
    }
}


// MARK: Appearance
private extension TickerCellViewModel {
    
    func createPriceText() -> String {
        
        let currencyType = currencyConfig.type
        let currencySymbol = currencyType.symbol
        let exchangeRate = currencyConfig.rate
        
        let dollarPrice: Decimal = tickerVO.price.wrappedNumber
        let formattedPrice = CVNumber(dollarPrice * Decimal(exchangeRate))
        var priceText = formattedPrice.roundToTwoDecimalPlaces()
        
        if currencyType.isPrefix {
            priceText = "\(currencySymbol) \(priceText)"
        } else {
            priceText = "\(priceText) \(currencySymbol)"
        }
        
        return priceText
    }
    
    func createImageURL() -> String {
        
        guard let firstSymbol = tickerVO.firstSymbol else { return "" }
        let baseURL = URL(string: "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/refs/heads/master/32/icon")!
        let symbolImageURL = baseURL.appendingPathComponent(firstSymbol.lowercased(), conformingTo: .png)
        
        return symbolImageURL.absoluteString
    }
    
    func createPercentText() -> String {
        tickerVO.changedPercent.roundToTwoDecimalPlaces().getPlusText() + " %"
    }
}


// MARK: Action & State
extension TickerCellViewModel {
    
    enum Action {
            
        case updatePriceText(String)
    }
    
    struct State {
        
        public var firstSymbolImageURL: String
        public var pairSymbolNameText: String
        public var priceText: String
        public var percentText: String
    }
}


// MARK: String + Extension
fileprivate extension String {
    
    func getPlusText() -> String {
        
        if let double = Double(self), double >= 0.0 {
            
            return "+" + self
        }
        
        return self
    }
}
