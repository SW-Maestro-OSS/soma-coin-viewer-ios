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
    
    private static func fetchImageUrlFromSymbol(_ symbol: String) -> URL {
        
        let baseURL = URL(string: "https://github.com/spothq/cryptocurrency-icons/tree/master/32/icon")!
        let symbolImageURL = baseURL.appendingPathComponent(symbol.lowercased() + "png")
        return symbolImageURL
    }
}

extension TickerListCellViewModel {
    
    enum Action {
            
    }
    
    struct State {
        
        var firstSymbolImageURL: URL
        var pairSymbolName: String
        var price: String
        var percent: String
    }
}
