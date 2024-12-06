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

import SimpleImageProvider

class TickerListCellViewModel: Identifiable, UDFObservableObject {
    
    public let id: String
    
    @Published public var state: State
    
    private(set) var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
    
    init(tickerVO: Twenty4HourTickerForSymbolVO) {
        
        self.id = tickerVO.pairSymbol
        
        let initialState: State = .init(
            pairSymbolName: tickerVO.pairSymbol,
            price: tickerVO.price.roundToTwoDecimalPlaces().description,
            percent: tickerVO.changedPercent.roundToTwoDecimalPlaces().description + "%"
        )
        self._state = Published(initialValue: initialState)
        
        createStateStream()
        
        fetchImageUrlFromSymbol(tickerVO.firstSymbol)
    }
    
    func reduce(_ action: Action, state: State) -> State {
        switch action {
        case .imageLoaded(let uIImage):
            var newState = state
            newState.firstSymbolImage = uIImage
            
            return newState
        }
    }
    
    private func fetchImageUrlFromSymbol(_ symbol: String) {
        
        let baseURL = URL(string: "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/refs/heads/master/32/icon/")!
        let symbolImageURL = baseURL.appendingPathComponent(symbol.lowercased(), conformingTo: .png)
        
        Task {
            
            guard let image = await SimpleImageProvider.shared
                .requestImage(url: symbolImageURL.absoluteString, size: .init(width: 32, height: 32)) else { return }
            
            action.send(.imageLoaded(image))
        }
    }
}

extension TickerListCellViewModel {
    
    enum Action {
            
        case imageLoaded(UIImage)
    }
    
    struct State {
        
        public var firstSymbolImage: UIImage?
        public var pairSymbolName: String
        public var price: String
        public var percent: String
    }
}
