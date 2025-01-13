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
    
    public let id: String
    
    @Published public var state: State
    
    private(set) var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    let tickerVO: Twenty4HourTickerForSymbolVO
    
    init(tickerVO: Twenty4HourTickerForSymbolVO) {
        
        self.tickerVO = tickerVO
        self.id = tickerVO.pairSymbol
        
        let initialState: State = .init(
            firstSymbolImageURL: Self.createImageURL(tickerVO.firstSymbol),
            pairSymbolNameText: tickerVO.pairSymbol,
            priceText: tickerVO.price.roundToTwoDecimalPlaces(),
            percentText: tickerVO.changedPercent.roundToTwoDecimalPlaces().getPlusText() + " %"
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
    
    
    private static func createImageURL(_ symbol: String) -> String {
        
        let baseURL = URL(string: "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/refs/heads/master/32/icon")!
        let symbolImageURL = baseURL.appendingPathComponent(symbol.lowercased(), conformingTo: .png)
        
        return symbolImageURL.absoluteString
    }
}


// MARK: Public interface
extension TickerCellViewModel {
    
    func update(priceText: String) {
        action.send(.updatePriceText(priceText))
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
