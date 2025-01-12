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

class TickerCellViewModel: Identifiable, UDFObservableObject {
    
    public let id: String
    
    @Published public var state: State
    
    private(set) var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    init(tickerVO: Twenty4HourTickerForSymbolVO) {
        
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
        
        return state
    }
    
    private static func createImageURL(_ symbol: String) -> String {
        
        let baseURL = URL(string: "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/refs/heads/master/32/icon")!
        let symbolImageURL = baseURL.appendingPathComponent(symbol.lowercased(), conformingTo: .png)
        
        return symbolImageURL.absoluteString
    }
}

extension TickerCellViewModel {
    
    enum Action {
            
        
    }
    
    struct State {
        
        public var firstSymbolImageURL: String
        public var pairSymbolNameText: String
        public var priceText: String
        public var percentText: String
    }
}

fileprivate extension String {
    
    func getPlusText() -> String {
        
        if let double = Double(self), double >= 0.0 {
            
            return "+" + self
        }
        
        return self
    }
}
