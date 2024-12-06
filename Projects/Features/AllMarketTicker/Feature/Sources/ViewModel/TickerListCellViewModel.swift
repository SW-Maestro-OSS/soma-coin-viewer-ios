//
//  TickerListCellViewModel.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI
import Combine

import DomainInterface
import BaseFeatureInterface
import CoreUtil

class TickerListCellViewModel: UDFObservableObject {
    
    @Published var state: State
    
    private(set) var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    init(tickerVO: Twenty4HourTickerForSymbolVO) {
        
        let initialState: State = .init(
            firstSymbolImageURL: Self.fetchImageUrlFromSymbol(tickerVO.firstSymbol),
            pairSymbolName: tickerVO.pairSymbol,
            price: tickerVO.price.roundToTwoDecimalPlaces().description,
            percent: tickerVO.price.roundToTwoDecimalPlaces().description + "%"
        )
        self._state = Published(initialValue: initialState)
        
        createStateStream()
    }
    
    private static func fetchImageUrlFromSymbol(_ symbol: String) -> String {
        
        let baseURL = URL(string: "https://github.com/spothq/cryptocurrency-icons/tree/master/32/icon")!
        let symbolImageURL = baseURL.appendingPathComponent(symbol.lowercased(), conformingTo: .png)
        return symbolImageURL.absoluteString
    }
}

extension TickerListCellViewModel {
    
    enum Action {
            
    }
    
    struct State {
        
        public var firstSymbolImageURL: String
        public var pairSymbolName: String
        public var price: String
        public var percent: String
    }
}
