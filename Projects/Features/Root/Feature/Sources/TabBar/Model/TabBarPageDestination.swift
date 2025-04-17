//
//  TabBarPageDestination.swift
//  RootModule
//
//  Created by choijunios on 4/17/25.
//

import CoinDetailFeature

enum TabBarPageDestination: Equatable, Hashable {
    case coinDetailPage(listener: CoinDetailPageListener, symbolInfo: CoinSymbolInfo)
    
    static func == (lhs: TabBarPageDestination, rhs: TabBarPageDestination) -> Bool {
        switch (lhs, rhs) {
        case let (.coinDetailPage(_, lhsSymbol), .coinDetailPage(_, rhsSymbol)):
            return lhsSymbol == rhsSymbol
        }
    }
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .coinDetailPage(_, symbolInfo):
            hasher.combine(self)
            hasher.combine(symbolInfo)
        }
    }
}
