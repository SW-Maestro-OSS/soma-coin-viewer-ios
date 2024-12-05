//
//  AllMarketTickerViewModel.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/5/24.
//

import SwiftUI
import Combine

import BaseFeatureInterface

class AllMarketTickerViewModel: UDFObservableObject {
    
    @Published var state: State = .init()
    
    var action: PassthroughSubject<Action, Never> = .init()
    var store: Set<AnyCancellable> = []
     
    init() {
        
        // Create state stream
        createStateStream()
    }
}

// MARK: State & Action
extension AllMarketTickerViewModel {
    
    struct State {
        
    }
    
    enum Action {
        
        // Event
        
        
        // Side effect
        
    }
}

// MARK: Stream
extension AllMarketTickerViewModel {
    
    enum Stream {
        
        
    }
}
